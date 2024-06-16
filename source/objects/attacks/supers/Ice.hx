package objects.attacks.supers;

import flixel.FlxG;
import flixel.util.FlxColor;
import objects.characters.BaseCharacter;
import states.SelectionState;

class Ice extends BaseProjectile
{
	private var target:BaseCharacter;

	public function new()
	{
		super('ice', 0, 1.5);
	}

	override function draw():Void
	{
		if (alive && (target == null || !target.stunned))
		{
			kill();
			target = null;
			FlxG.camera.flash(FlxColor.WHITE, 0.1);
		}

		super.draw();
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		target.health -= elapsed * damage;
	}

	public function setTarget(target:BaseCharacter):Void
	{
		this.target = target;

		this.setPosition(target.x + (target.width - this.width) / 2, target.y + (target.height - this.height) / 2);
		target.freeze(Std.parseFloat(SelectionState.habilitiesJSON.get(type).duration));

		alpha = 0.35;

		FlxG.sound.play('assets/sounds/win.mp3', 0.5).pitch = 0.5;
	}
}
