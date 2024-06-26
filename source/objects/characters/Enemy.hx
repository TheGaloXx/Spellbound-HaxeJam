package objects.characters;

import flixel.FlxG;
import flixel.math.FlxMath;
import states.PlayState;

class Enemy extends BaseCharacter
{
	@:noCompletion
	private static final AI_level_bounds:Array<Int> = [1, 10];

	public var AI_level:Null<Int>;

	private var moveFrequency:Null<Float>;

	private var targetX:Null<Float>;
	private var targetY:Null<Float>;

	public function new(AI_level:Int)
	{
		super('red', CharacterBuild.randomize());

		flipX = true;
		this.AI_level = Std.int(FlxMath.bound(AI_level, AI_level_bounds[0], AI_level_bounds[1]));
		// this.AI_level = 0;

		setMovementFrequency();

		// FlxG.debugger.track(this, 'AI');
	}

	private inline function setMovementFrequency():Void
	{
		final minTime:Float = 0.25;
		final maxTime:Float = 4;
		final maxLevel:Int = AI_level_bounds[1];

		moveFrequency = minTime + ((maxLevel - AI_level) * (maxTime - minTime) / maxLevel);
	}

	var moveTimer:Null<Float> = 0;
	var attackTimer:Null<Float> = 0;
	var distanceFromTarget:Null<Float>;

	override function update(elapsed:Float):Void
	{
		if (AI_level == 0)
		{
			super.update(elapsed);
			return;
		}

		if (canMove)
		{
			moveTimer -= elapsed;
			if (moveTimer <= 0)
			{
				moveTimer = moveFrequency;
				calculateMovement();
			}

			var directionX:Float = targetX - x;
			var directionY:Float = targetY - y;
			distanceFromTarget = Math.sqrt(directionX * directionX + directionY * directionY);

			if (distanceFromTarget > 0)
			{
				directionX /= distanceFromTarget;
				directionY /= distanceFromTarget;
				velocity.x = directionX * speed;
				velocity.y = directionY * speed;
			}

			if (distanceFromTarget < speed * elapsed)
			{
				velocity.x = 0;
				velocity.y = 0;
				// calculateMovement();
			}

			if (velocity.x != 0)
				flipX = velocity.x < 0;

			if (velocity.x != 0 || velocity.y != 0)
				playAnim('walk');
			else
				playAnim('idle');
		}

		if (acceptInput && cooldown <= 0)
		{
			attackTimer += elapsed;

			if (attackTimer > moveFrequency * 1.1)
			{
				attackTimer = 0;

				final player = PlayState.current.player;

				throwAttack(FlxG.random.bool(), player.x + player.width / 2, player.y + player.height / 2);
			}
		}

		if (canUseSuper() && FlxG.random.bool(0.05 * AI_level))
			throwSuper();

		super.update(elapsed);

		FlxG.watch.addQuick('AI:', this);
	}

	override function throwAttack(primary1:Bool, targetX:Float, targetY:Float)
	{
		super.throwAttack(primary1, targetX + ((primary1 ? build.primary1 : build.primary2) == 'bottle' ? -35 : 0), targetY);
	}

	private inline function calculateMovement():Void
	{
		targetX = FlxG.width / 2 + FlxG.random.float(0, FlxG.width / 2 - width);
		targetY = FlxG.random.float(0, FlxG.height - height);
	}

	override function destroy():Void
	{
		super.destroy();

		AI_level = null;
		moveFrequency = null;
		targetX = null;
		targetY = null;
		moveTimer = null;
		attackTimer = null;
		distanceFromTarget = null;
	}

	override public function toString():String
	{
		return 'AI level: $AI_level-' + 'Move freq.: $moveFrequency-' + 'Move timer: $moveTimer-' + 'Target distance: $distanceFromTarget-'
			+ 'Velocity: $velocity';
	}
}
