package objects.attacks;

import flixel.FlxSprite;
import objects.characters.BaseCharacter;
import scripts.Module;
import scripts.ScriptHandler;
import states.SelectionState;

class BaseProjectile extends FlxSprite
{
	private inline static final frameSize:Int = 16;

	private var size:Null<Float>;
	private var hitboxSize:Null<Float>;

	public var type:String;
	public var parent:BaseCharacter;
	public var damage:Null<Float>;
	public var magicGain:Null<Float> = 10;
	public var speed:Null<Float>;

	public var script:Module;

	public function new(type:String, speed:Float, size:Float = 1, hitboxSize:Float = 1)
	{
		super();

		this.type = type;
		this.speed = speed;
		this.size = size;
		this.hitboxSize = hitboxSize;
		this.script = ScriptHandler.modules.get(type);

		loadGraphic('assets/images/gameplay/attacks.png', true, 16, 16);
		animation.add('bottle', [1, 3, 7], 0, false);
		animation.add('spear', [8], 0, false);
		animation.add('prism', [9], 0, false);
		animation.add('ice', [2], 0, false);
		animation.add('light', [12, 13, 14, 15, 16, 17], 12, true);
		animation.add('fire', [0, 6], 12, true);
		animation.play(type);

		setGraphicSize(frameSize * Main.pixel_mult);
		updateHitbox();

		damage = SelectionState.attackProperty(type, 'damage');
	}

	public function init(posX:Float, posY:Float):Void
	{
		setPosition(posX, posY);

		velocity.set();
		acceleration.set();
		setGraphicSize(frameSize * Main.pixel_mult);
		updateHitbox();
		final scaleX = scale.x * size;
		final scaleY = scale.y * size;
		scale.set(scaleX * hitboxSize, scaleY * hitboxSize);
		updateHitbox();
		scale.set(scaleX, scaleY);

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
		if (script != null)
			script.run("onKill");

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

	override function destroy():Void
	{
		super.destroy();

		size = null;
		hitboxSize = null;
		type = null;
		parent = null;
		damage = null;
		magicGain = null;
		speed = null;
	}
}
