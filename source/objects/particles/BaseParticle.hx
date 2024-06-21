package objects.particles;

import flixel.FlxSprite;

class BaseParticle extends FlxSprite
{
	public var type:String;

	public function new(type:String)
	{
		super();

		this.type = type;

		switch (type)
		{
			case 'sparks':
				loadGraphic('assets/images/particles/sparks.png', true, 32, 32);
				animation.add('sparks', [0, 1, 2, 3, 4], 12, false);
				animation.play(type);

				setGraphicSize(32 * Main.pixel_mult);
			case 'explosion':
				loadGraphic('assets/images/particles/explosion.png', true, 22, 22);
				animation.add('explosion', [5, 4, 3, 2, 1, 0], 12, false);
				animation.play(type);

				setGraphicSize(22 * Main.pixel_mult);
			default:
				loadGraphic('assets/images/particles/particles.png', true, 16, 16);
				animation.add('bottle', [0, 1, 2, 3, 4], 12, false);
				animation.add('smoke', [5, 6, 7], 0, false);
				animation.play(type);

				setGraphicSize(16 * Main.pixel_mult);
		}

		updateHitbox();
	}

	public function init(posX:Float, posY:Float):Void
	{
		setPosition(posX, posY);

		velocity.set();
		acceleration.set();

		angle = 0;
		alpha = 1;

		visible = true;
		active = true;
	}

	override function kill():Void
	{
		active = false;

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

		type = null;
	}
}
