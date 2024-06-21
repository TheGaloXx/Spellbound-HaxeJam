package objects.attacks;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import objects.characters.BaseCharacter;
import objects.particles.BottleSplash;
import states.PlayState;

class Bottle extends BaseProjectile
{
	private var target:FlxPoint = FlxPoint.get();

	public function new()
	{
		super('bottle', 700, 0.7, 0.9);
	}

	override public function init(posX:Float, posY:Float):Void
	{
		super.init(posX, posY);

		animation.curAnim.curFrame = FlxG.random.int(0, 2);

		startX = x;
		startY = y;
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		angle += elapsed * 3600;

		time += elapsed;
		var t:Float = time / totalTime;
		x = (1 - t) * startX + t * target.x;
		y = (1 - t) * startY + t * target.y - curveSize * 4 * t * (1 - t);

		if (Math.abs(1 - t) < 0.05)
		{
			kill();
		}
	}

	var startX:Float;
	var startY:Float;
	var time:Float;
	var totalTime:Float;
	var curveSize:Float;

	public function setTarget(tarX:Float, tarY:Float):Void
	{
		target.set(tarX, tarY);

		var distance:Float = FlxMath.distanceToPoint(this, target);
		totalTime = distance / speed;
		time = 0;
		curveSize = distance / 4;
	}

	override function destroy():Void
	{
		super.destroy();

		target.put();
	}

	override function kill():Void
	{
		super.kill();

		final manager = PlayState.current.particlesManager;
		if (manager != null)
		{
			var splash:BottleSplash = cast manager.getNewParticle('bottle');
			splash.init(this.x + (this.width - splash.width) / 2, this.y + (this.height - splash.height) / 2);
			splash.color = [0x14a02e, 0xb4202a, 0x249fde][this.animation.curAnim.curFrame];

			Main.sound('bottle_crash', 0.5);
		}
	}
}
