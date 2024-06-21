package objects.attacks.supers;

import flixel.FlxG;

class LightBall extends BaseProjectile
{
	public function new()
	{
		super('light', 200, 3, 0.8);
	}

	override function init(posX:Float, posY:Float):Void
	{
		super.init(posX, 0);

		y = (FlxG.height - this.height) / 2;
	}

	var time:Float = 0;

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		time += elapsed;
		y = (FlxG.height - this.height) / 2 + 300 * Math.sin(time * 2);
	}
}
