package objects.particles;

class Sparks extends BaseParticle
{
	public function new()
	{
		super('sparks');

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
