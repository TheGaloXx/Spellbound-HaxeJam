package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

using StringTools;

class Player extends FlxSprite
{
	private inline static final base_speed:Float = 300;

	private var timer:FlxTimer = null;

	public var speed_mult:Float = 1;
	public var canMove:Bool = true;
	public var acceptInput:Bool = true;

	public function new()
	{
		super();

		loadGraphic('assets/images/blue.png', true, 16, 16, false, 'BLUE_WIZARD');
		animation.add('idle', [0], 0, false);
		// animation.add('idle-blink', [1], 0, false);
		animation.add('attack', [2, 3], 12, false);
		animation.add('hurt', [4], 0, false);
		animation.add('cheer', [5, 6], 6, true);
		animation.add('walk', [7, 8, 9, 10, 11, 9], 12, true);
		animation.add('placeholder', [12], 0, false);

		playAnim('idle');

		setGraphicSize(width * Main.pixel_mult);
		updateHitbox();

		timer = new FlxTimer();
	}

	override function update(elapsed:Float):Void
	{
		input();

		super.update(elapsed);
	}

	private inline function input():Void
	{
		if (!acceptInput)
			return;

		if (canMove)
		{
			// MOVEMENT
			var left = FlxG.keys.pressed.A;
			var down = FlxG.keys.pressed.S;
			var up = FlxG.keys.pressed.W;
			var right = FlxG.keys.pressed.D;

			if (left && right)
			{
				left = false;
				right = false;
			}

			if (down && up)
			{
				down = false;
				up = false;
			}

			var speed:Float = base_speed * speed_mult;

			if (left)
			{
				velocity.x = -speed;
				flipX = true;
			}
			else if (right)
			{
				velocity.x = speed;
				flipX = false;
			}
			else
				velocity.x = 0;

			if (down)
				velocity.y = speed;
			else if (up)
				velocity.y = -speed;
			else
				velocity.y = 0;

			if ((left || down || up || right) && (velocity.x != 0 || velocity.y != 0))
				playAnim('walk');
			else
				playAnim('idle');
		}

		if (FlxG.mouse.justPressed || FlxG.mouse.justPressedRight)
		{
			specialAnim('attack');
		}

		if (FlxG.keys.justPressed.SPACE)
		{
			specialAnim('cheer', 1);
		}
	}

	private function playAnim(name:String, force:Bool = false, frame:Int = 0):Void
	{
		if (animation.exists(name))
			animation.play(name, force, false, frame);
		else
			animation.play('placeholder');
	}

	private function specialAnim(name:String, time:Float = 0.3):Void
	{
		playAnim(name, true);

		canMove = false;
		acceptInput = false;
		velocity.set();

		timer.start(time, (_) ->
		{
			canMove = true;
			acceptInput = true;
			playAnim('idle');
		});
	}
}
