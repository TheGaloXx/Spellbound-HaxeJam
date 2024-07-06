var title = "Spear of Light";
var description = "Throws a spear made of light that deals decent damage. Just aim at the opponent with it.";
var frameSize = 16;
var animated = false;
var speed = 1300;
var size = 0.8;
var hitboxSize = 0.8;
var damage = 7;
var cooldown = 1.25;
function onInit() {}

function onRun(self, state)
{
	Utils.snapToSprite(self.parent, self);

	var dx:Float = self.getAimPoint().x - self.x - self.width / 2;
	var dy:Float = self.getAimPoint().y - self.y - self.height / 2;
	var distance:Float = Math.sqrt(dx * dx + dy * dy);

	self.velocity.x = self.speed * (dx / distance);
	self.velocity.y = self.speed * (dy / distance);

	self.angle = Math.atan2(dy, dx) * 180 / Math.PI;
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
