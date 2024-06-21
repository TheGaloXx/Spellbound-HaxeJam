package objects.particles;

class Explosion extends BaseParticle
{
	public function new()
	{
		super('explosion');

		moves = false;
	}

	override public function init(posX:Float, posY:Float):Void
	{
		super.init(posX, posY);

		animation.play(type);

		animation.finishCallback = (curAnim:String) ->
		{
			if (curAnim == type)
				kill();
		}
	}
}
