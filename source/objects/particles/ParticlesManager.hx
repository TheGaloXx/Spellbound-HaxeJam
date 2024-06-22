package objects.particles;

import flixel.group.FlxContainer.FlxTypedContainer;
import flixel.util.FlxSort;

class ParticleManager extends FlxTypedContainer<BaseParticle>
{
	public var smokeTime:Float = 0;

	public function new()
	{
		super();

		for (type in ['bottle', 'sparks', 'explosion', 'smoke'])
		{
			getNewParticle(type).kill(); // spawn at least one of each so it doesnt lag the first time you generate them
		}
	}

	override function update(elapsed:Float):Void
	{
		smokeTime += elapsed;

		super.update(elapsed);

		sort(FlxSort.byY);
	}

	public function getNewParticle(type:String):BaseParticle
	{
		var particle:BaseParticle = null;

		for (member in members)
		{
			if (!member.alive && member.type == type)
			{
				particle = member;
				particle.revive();

				break;
			}
		}

		if (particle == null)
		{
			particle = switch (type)
			{
				case 'bottle':
					new BottleSplash();
				case 'sparks':
					new Sparks();
				case 'explosion':
					new Explosion();
				case 'smoke':
					new Smoke();
				default:
					new BottleSplash();
			}

			add(particle);
		}

		return particle;
	}
}
