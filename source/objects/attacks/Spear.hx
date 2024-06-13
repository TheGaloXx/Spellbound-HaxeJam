package objects.attacks;

class Spear extends BaseProjectile
{
	public function new()
	{
		super('spear', 20, 0.8);
	}

	public function setTarget(posX:Float, posY:Float):Void
	{
		var dx:Float = posX - x - width / 2;
		var dy:Float = posY - y - height / 2;
		var distance:Float = Math.sqrt(dx * dx + dy * dy);

		velocity.x = 1500 * (dx / distance);
		velocity.y = 1500 * (dy / distance);

		angle = Math.atan2(dy, dx) * 180 / Math.PI;
	}
}
