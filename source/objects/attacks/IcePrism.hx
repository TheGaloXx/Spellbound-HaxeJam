package objects.attacks;

class IcePrism extends BaseProjectile
{
	public function new()
	{
		super('prism', 900, 1);
	}

	public function setTarget(posX:Float, posY:Float, ?newAngle:Float):Void
	{
		if (newAngle != null)
		{
			var radians:Float = newAngle * Math.PI / 180;
			velocity.x = speed * Math.cos(radians);
			velocity.y = speed * Math.sin(radians);

			angle = newAngle;
		}
		else
		{
			var dx:Float = posX - x - width / 2;
			var dy:Float = posY - y - height / 2;
			var distance:Float = Math.sqrt(dx * dx + dy * dy);

			velocity.x = speed * (dx / distance);
			velocity.y = speed * (dy / distance);

			angle = Math.atan2(dy, dx) * 180 / Math.PI;
		}
	}
}
