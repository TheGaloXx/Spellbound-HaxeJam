package objects.particles;

import flixel.tweens.FlxTween;

class BottleSplash extends BaseParticle
{
	public function new()
	{
		super('bottle');

		moves = false;
	}

	override public function init(posX:Float, posY:Float):Void
	{
		FlxTween.cancelTweensOf(this);

		super.init(posX, posY);

		animation.play(type);

		animation.finishCallback = (curAnim:String) ->
		{
			if (curAnim == type)
				FlxTween.tween(this, {alpha: 0}, 2, {startDelay: 1, onComplete: (_) -> kill()});
		}
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
