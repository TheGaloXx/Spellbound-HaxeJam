package objects.characters;

import flixel.FlxG;
import objects.attacks.Bottle;
import objects.attacks.Spear;
import states.PlayState;

class Player extends BaseCharacter
{
	public function new()
	{
		super('blue');
	}

	override function update(elapsed:Float):Void
	{
		input();

		super.update(elapsed);
	}

	private inline function input():Void
	{
		if (!acceptInput)
			return;

		if (canMove)
			updateMovement();

		if (FlxG.mouse.justPressed || FlxG.mouse.justPressedRight)
		{
			if (FlxG.mouse.justPressed)
			{
				throwAttack('prism', FlxG.mouse.screenX, FlxG.mouse.screenY);
			}
			else
			{
				throwAttack('bottle', FlxG.mouse.screenX, FlxG.mouse.screenY);
			}
		}

		if (FlxG.keys.justPressed.SPACE)
		{
			specialAnim('cheer', 1);
		}
	}

	private inline function updateMovement():Void
	{
		var left = FlxG.keys.pressed.A;
		var down = FlxG.keys.pressed.S;
		var up = FlxG.keys.pressed.W;
		var right = FlxG.keys.pressed.D;

		if (left && right)
		{
			left = false;
			right = false;
		}

		if (down && up)
		{
			down = false;
			up = false;
		}

		if (left)
		{
			velocity.x = -speed;
			flipX = true;
		}
		else if (right)
		{
			velocity.x = speed;
			flipX = false;
		}
		else
			velocity.x = 0;

		if (down)
			velocity.y = speed;
		else if (up)
			velocity.y = -speed;
		else
			velocity.y = 0;

		if ((left || down || up || right) && (velocity.x != 0 || velocity.y != 0))
			playAnim('walk');
		else
			playAnim('idle');
	}
}
