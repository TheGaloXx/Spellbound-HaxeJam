package objects.characters;

import flixel.FlxG;

class CharacterBuild
{
	public var primary1:String;
	public var primary2:String;

	public var super1:String;
	public var super2:String;

	public function new() {}

	public static function randomize():CharacterBuild
	{
		var primaries:Array<String> = ['spear', 'bottle', 'prism'];
		var supers:Array<String> = ['ice', 'fire', 'light'];

		var build = new CharacterBuild();
		build.primary1 = FlxG.random.getObject(primaries);
		primaries.remove(build.primary1);
		build.primary2 = FlxG.random.getObject(primaries);

		build.super1 = FlxG.random.getObject(supers);
		supers.remove(build.super1);
		build.super2 = FlxG.random.getObject(supers);

		trace('Randomized build: $build.');

		return build;
	}

	public function setPrimary(newAttack:String):Void
	{
		// if there's no primary 1
		if (primary1 == null)
		{
			primary1 = newAttack; // assign it the attack given
		}
		else // if there IS a primary1
		{
			if (primary2 == null) // if there's no primary 2 but there's a primary 1
			{
				primary2 = newAttack; // just make the primary 2 the attack given
			}
			else // otherwise
			{
				primary1 = newAttack; // replace the primary 1 with the attack given
			}
		}
	}

	public function setSuper(newAttack:String):Void
	{
		// same thing as the other function
		if (super1 == null)
		{
			super1 = newAttack;
		}
		else
		{
			if (super2 == null)
			{
				super2 = newAttack;
			}
			else
			{
				super1 = newAttack;
			}
		}
	}

	public function toString()
	{
		return '(Primaries: [$primary1, $primary2] - Supers: [$super1, $super2])';
	}
}
