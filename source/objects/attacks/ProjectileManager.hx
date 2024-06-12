package objects.attacks;

import flixel.group.FlxContainer.FlxTypedContainer;
import flixel.util.FlxSort;

class ProjectileManager extends FlxTypedContainer<BaseProjectile>
{
	public function new()
	{
		super();

		for (type in ['spear'])
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
			projectile = switch (type)
			{
				case 'spear':
					new Spear();
				default:
					new Spear();
			}

			add(projectile);
		}

		return projectile;
	}
}
