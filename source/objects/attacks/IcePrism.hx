package objects.attacks;

class IcePrism extends BaseProjectile
{
	public function new()
	{
		super('prism', 1);
	}

	public function setTarget(posX:Float, posY:Float, ?newAngle:Float):Void
	{
		if (newAngle != null)
		{
			var radians:Float = newAngle * Math.PI / 180;
			velocity.x = 1000 * Math.cos(radians);
			velocity.y = 1000 * Math.sin(radians);

			angle = newAngle;
		}
		else
		{
			var dx:Float = posX - x - width / 2;
			var dy:Float = posY - y - height / 2;
			var distance:Float = Math.sqrt(dx * dx + dy * dy);

			velocity.x = 1000 * (dx / distance);
			velocity.y = 1000 * (dy / distance);

			angle = Math.atan2(dy, dx) * 180 / Math.PI;
		}
	}
}
