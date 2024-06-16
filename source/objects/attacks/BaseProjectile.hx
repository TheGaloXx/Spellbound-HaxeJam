package objects.attacks;

import flixel.FlxSprite;
import objects.characters.BaseCharacter;
import states.SelectionState;

class BaseProjectile extends FlxSprite
{
	private inline static final frameSize:Int = 16;

	private var size:Float;

	public var type:String;
	public var parent:BaseCharacter;
	public var damage:Float;
	public var magicGain:Float = 10;
	public var speed:Float;

	public function new(type:String, speed:Float, size:Float = 1)
	{
		super();

		this.type = type;
		this.speed = speed;
		this.size = size;

		loadGraphic('assets/images/attacks.png', true, 16, 16);
		animation.add('bottle', [1, 3, 7], 0, false);
		animation.add('spear', [8], 0, false);
		animation.add('prism', [9], 0, false);
		animation.add('ice', [2], 0, false);
		animation.add('light', [12, 13, 14, 15, 16, 17], 12, true);
		animation.play(type);

		setGraphicSize(frameSize * Main.pixel_mult);
		updateHitbox();

		damage = Std.parseFloat(SelectionState.habilitiesJSON.get(type).damage);
	}

	public function init(posX:Float, posY:Float):Void
	{
		setPosition(posX, posY);

		velocity.set();
		acceleration.set();
		setGraphicSize(frameSize * Main.pixel_mult);
		updateHitbox();
		scale.x *= size;
		scale.y *= size;

		angle = 0;
		alpha = 1;

		visible = true;
		active = true;

		checkTime = 0;
		timeAlive = 0;

		parent = null;
	}

	override function kill():Void
	{
		active = false;
		parent = null;

		super.kill();
	}

	@:noCompletion var timeAlive:Float = 0;
	@:noCompletion var checkDelay:Float = 3;
	@:noCompletion var checkTime:Float = 0;

	override function update(elapsed:Float):Void
	{
		// check every 3 seconds (after 3 seconds of spawning) if this projectile is offcamera, kill it if it is
		if (timeAlive < 3)
			timeAlive += elapsed;
		else
		{
			checkTime += elapsed;
			if (checkTime >= checkDelay)
			{
				checkTime = 0;

				if (!isOnScreen())
					kill();
			}
		}

		super.update(elapsed);
	}
}
