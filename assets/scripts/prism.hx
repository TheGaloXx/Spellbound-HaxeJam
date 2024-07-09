var title = "Ice Prism";
var description = "Summon three ice prisms that deal low damage and slow the opponent's movement speed.";
var frameSize = 16;
var animated = false;
var speed = 900;
var size = 1;
var hitboxSize = 0.7;
var damage = 7;
var cooldown = 1.6;

function onRun(self, state)
{
	// for the first prism
	var firstAngle:Float = 0;

	for (i in 0...3)
	{
		if (i == 0)
		{
			Utils.snapToSprite(self.parent, self);
			setTarget(self, self.getAimPoint().x, self.getAimPoint().y, null);
			firstAngle = self.angle;
		}
		else
		{
			// for the other 2 prisms
			var prism = state.projectilesManager.getNewProjectile('prism');
			Utils.snapToSprite(self.parent, prism);
			prism.init(self.parent, false);
			setTarget(prism, 0, 0, firstAngle + 20 * (i == 1 ? -1 : 1));
		}
	}
}

function setTarget(prism, posX, posY, newAngle)
{
	if (newAngle != null)
	{
		var radians:Float = newAngle * Math.PI / 180;
		prism.velocity.x = prism.speed * Math.cos(radians);
		prism.velocity.y = prism.speed * Math.sin(radians);

		prism.angle = newAngle;
	}
	else
	{
		var dx:Float = posX - prism.x - prism.width / 2;
		var dy:Float = posY - prism.y - prism.height / 2;
		var distance:Float = Math.sqrt(dx * dx + dy * dy);

		prism.velocity.x = prism.speed * (dx / distance);
		prism.velocity.y = prism.speed * (dy / distance);

		prism.angle = Math.atan2(dy, dx) * 180 / Math.PI;
	}
}

/*








 */
function get_frameSize()
	return frameSize;

function get_animated()
	return animated;

function get_speed()
	return speed;

function get_size()
	return size;

function get_hitboxSize()
	return hitboxSize;

function get_damage()
	return damage;

function get_cooldown()
	return cooldown;
