package objects.attacks;

import flixel.group.FlxContainer.FlxTypedContainer;
import flixel.util.FlxSort;
import objects.characters.BaseCharacter;
import states.PlayState;

class ProjectileManager extends FlxTypedContainer<BaseProjectile>
{
	public function new()
	{
		super();

		for (type in ['spear', 'bottle', 'prism', 'ice', 'light', 'fire'])
		{
			getNewProjectile(type).kill(); // spawn at least one of each so it doesnt lag the first time you generate them
		}
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		sort(FlxSort.byY);
	}

	public function getNewProjectile(type:String):BaseProjectile
	{
		var projectile:BaseProjectile = null;

		for (member in members)
		{
			if (!member.alive && member.type == type)
			{
				projectile = member;
				projectile.revive();

				break;
			}
		}

		if (projectile == null)
		{
			/*
				projectile = switch (type)
				{
						case 'spear':
							new Spear();
						case 'bottle':
							new Bottle();
						case 'prism':
							new IcePrism();
						case 'ice':
							new Ice();
						case 'light':
							new LightBall();
						case 'fire':
							new Fire();
					default:
						new BaseProjectile('spear', 2, 2, 2);
			}*/

			projectile = new BaseProjectile(type, 2, 2, 2);
			add(projectile);
		}

		return projectile;
	}
}
