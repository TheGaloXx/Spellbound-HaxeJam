package objects.particles;

import flixel.FlxG;
import flixel.tweens.FlxTween;

class Smoke extends BaseParticle
{
	public function new()
	{
		super('smoke');
	}

	private static final minAlpha:Float = 0.25;
	private static final posOffset:Int = 20;
	private static final speed:Int = 60;

	override public function init(posX:Float, posY:Float):Void
	{
		super.init(posX, posY);

		animation.play(type, true, false, -1);
		angle = FlxG.random.int(0, 359);
		alpha = FlxG.random.float(minAlpha, 1);
		offset.set(FlxG.random.int(-posOffset, posOffset), FlxG.random.int(-posOffset, posOffset));
		velocity.set(FlxG.random.int(-speed, speed), FlxG.random.float(0, speed));
		drag.set(velocity.x / 2, velocity.y / 2);

		FlxTween.cancelTweensOf(this, ['alpha']);
		FlxTween.tween(this, {alpha: 0}, FlxG.random.float(0.2, 1.5), {startDelay: FlxG.random.float(0, 0.2), onComplete: (_) -> kill()});
	}
}
