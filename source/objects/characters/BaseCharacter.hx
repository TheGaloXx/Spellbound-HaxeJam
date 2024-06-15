package objects.characters;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import objects.attacks.BaseProjectile;
import objects.attacks.Bottle;
import objects.attacks.IcePrism;
import objects.attacks.Spear;
import objects.ui.Bar;
import states.PlayState;
import states.SelectionState;

using StringTools;

class BaseCharacter extends FlxSprite
{
	private inline static final base_speed:Float = 300;

	private var timer:FlxTimer = null;

	public var build:CharacterBuild;
	public var speed_mult:Float = 1;
	public var canMove:Bool = true;
	public var acceptInput:Bool = true;
	public var stunned:Bool = false;
	public var health(default, set):Float = 100;
	public var magic(default, set):Float = 0;
	public var hudBar:Bar;
	public var dead:Bool = false;

	public var cooldown:Float = 0;

	private var maxCooldown:Float = 0;
	private var cooldownBar:FlxSprite;

	public var speed(get, default):Float;

	function get_speed():Float
	{
		return base_speed * speed_mult;
	}

	public function new(path:String, build:CharacterBuild)
	{
		super();

		this.build = build;

		loadGraphic('assets/images/characters/$path.png', true, 16, 16, false, path + '_WIZARD');
		animation.add('idle', [0], 0, false);
		// animation.add('idle-blink', [1], 0, false);
		animation.add('attack', [2, 3], 12, false);
		animation.add('hurt', [4], 0, false);
		animation.add('cheer', [5, 6], 6, true);
		animation.add('walk', [7, 8, 9, 10, 11, 9], 12, true);
		animation.add('cast', [12, 13, 14, 15], 12, false);
		animation.add('dead', [16], 0, false);
		animation.add('placeholder', [17], 0, false);

		playAnim('idle');

		setGraphicSize(width * Main.pixel_mult);
		updateHitbox();

		timer = new FlxTimer();
		cooldownBar = new FlxSprite().makeGraphic(1, 1, FlxColor.GRAY);
		cooldownBar.alpha = 0.7;
		cooldownBar.scale.y = 20;
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		magic += elapsed;
		if (cooldown > 0)
		{
			cooldown -= elapsed;
			cooldownBar.scale.x = (cooldown / maxCooldown) * this.width * 0.8;
			cooldownBar.updateHitbox();
			cooldownBar.setPosition(this.x + (this.width - this.width * 0.8) / 2, this.y - cooldownBar.height - 10);
		}
		else
			cooldown = 0;
	}

	override function draw():Void
	{
		super.draw();
		if (cooldown > 0)
			cooldownBar.draw();
	}

	override function destroy():Void
	{
		super.destroy();
		cooldownBar.destroy();
	}

	private function playAnim(name:String, force:Bool = false, frame:Int = 0):Void
	{
		if (animation.exists(name))
			animation.play(name, force, false, frame);
		else
			animation.play('placeholder');
	}

	public function specialAnim(name:String, time:Float = 0.3):Void
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

	public function hurt(damage:Float, projectile:BaseProjectile):Void
	{
		if (stunned)
			return;

		health -= damage;

		canMove = false;
		acceptInput = false;
		stunned = true;

		flipX = projectile.x + width / 2 < this.x + width / 2;

		FlxTween.cancelTweensOf(this, ['x', 'y']);
		FlxFlicker.stopFlickering(this);

		if (health <= 0)
		{
			dead = true;

			specialAnim('dead', 9999);
			FlxG.sound.play('assets/sounds/dead.mp3');

			FlxTween.tween(this, {x: this.x + (Std.isOfType(this, Player) ? -60 : 60)}, 1, {ease: FlxEase.sineOut});
			PlayState.current.endBattle();

			return;
		}
		else
			FlxG.sound.play('assets/sounds/hurt.mp3', 0.5);

		FlxTween.shake(this, 0.05, 0.5, XY, {
			onComplete: (_) ->
			{
				canMove = true;
				acceptInput = true;
				FlxFlicker.flicker(this, 1.5, 0.04, true, true, (_) -> stunned = false);
			}
		});

		specialAnim('hurt', 1);
	}

	public function throwAttack(primary1:Bool, targetX:Float, targetY:Float):Void
	{
		if (cooldown > 0)
		{
			FlxG.sound.play('assets/sounds/error.mp3', 0.4).pitch = 0.8;
			return;
		}

		specialAnim('attack');

		var type:String = (primary1 ? build.primary1 : build.primary2);

		switch (type)
		{
			case 'spear':
				var spear:Spear = cast PlayState.current.projectilesManager.getNewProjectile('spear');
				spear.init(this.x + (this.width - spear.width) / 2, this.y + (this.height - spear.height) / 2);
				spear.setTarget(targetX, targetY);
				spear.parent = this;

				FlxG.sound.play('assets/sounds/throw.mp3', 0.5);
			case 'bottle':
				var bottle:Bottle = cast PlayState.current.projectilesManager.getNewProjectile('bottle');
				bottle.init(this.x + (this.width - bottle.width) / 2, this.y + (this.height - bottle.height) / 2);
				bottle.setTarget(targetX, targetY);
				bottle.parent = this;

				FlxG.sound.play('assets/sounds/throw.mp3', 0.5);
			case 'prism':
				var firstAngle:Float = 361;
				for (i in 0...3)
				{
					var prism:IcePrism = cast PlayState.current.projectilesManager.getNewProjectile('prism');
					prism.init(this.x + (this.width - prism.width) / 2, this.y + (this.height - prism.height) / 2);
					prism.parent = this;

					if (firstAngle == 361)
					{
						prism.setTarget(targetX, targetY);
						firstAngle = prism.angle;
					}
					else
					{
						prism.setTarget(0, 0, firstAngle + 20 * (i == 1 ? -1 : 1));
					}
				}

				FlxG.sound.play('assets/sounds/prism.mp3', 0.3);
		}

		setCooldown(Std.parseFloat(SelectionState.habilitiesJSON.get(type).cooldown));
		flipX = targetX < this.x + this.width / 2;
	}

	public function throwSuper():Void
	{
		flipX = (Std.isOfType(this, Player) ? false : true);
		specialAnim('cast', 99999999);

		PlayState.current.onSuperThrown(this, flipX);
	}

	function set_health(value:Float):Float
	{
		value = FlxMath.bound(value, 0, 100);

		if (health == value)
			return health;

		health = value;
		hudBar.updateHealthBar(health);

		return health;
	}

	function set_magic(value:Float):Float
	{
		value = FlxMath.bound(value, 0, 100);

		if (magic == value)
			return magic;

		magic = value;
		hudBar.updateMagicBar(magic);

		return magic;
	}

	public function setCooldown(value:Float):Float
	{
		if (value < 0)
			value = 0;

		cooldown = value;
		maxCooldown = value;

		return cooldown;
	}
}
