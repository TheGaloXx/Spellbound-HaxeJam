package objects.attacks.supers;

class Fire extends BaseProjectile
{
	public function new()
	{
		super('fire', 1450, 0.8);
	}

	public function setTarget(posX:Float, posY:Float):Void
	{
		var dx:Float = posX - x - width / 2;
		var dy:Float = posY - y - height / 2;
		var distance:Float = Math.sqrt(dx * dx + dy * dy);

		velocity.x = speed * (dx / distance);
		velocity.y = speed * (dy / distance);
	}
}
