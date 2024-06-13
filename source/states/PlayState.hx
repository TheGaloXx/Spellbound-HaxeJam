package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import objects.*;
import objects.attacks.BaseProjectile;
import objects.attacks.ProjectileManager;
import objects.characters.*;
import objects.particles.ParticlesManager.ParticleManager;
import objects.particles.Sparks;
import objects.ui.*;

class PlayState extends FlxState
{
	public static var current:PlayState = null;

	private var bg:FlxSprite;

	public var characters:FlxTypedGroup<BaseCharacter>;

	public var player:Player;
	public var enemy:Enemy;

	public var hud:HUD;

	public var projectilesManager:ProjectileManager;
	public var particlesManager:ParticleManager;

	override public function new()
	{
		super();

		current = this;
	}

	function addStage():Void
	{
		bg = new FlxSprite();
		bg.active = false;
		bg.loadGraphic('assets/images/background.png');
		bg.setGraphicSize(bg.width * Main.pixel_mult);
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);
	}

	function addCharacters():Void
	{
		characters = new FlxTypedGroup<BaseCharacter>();
		add(characters);

		enemy = new Enemy(SelectionState.curLevel);
		enemy.screenCenter();
		enemy.x += 350;
		characters.add(enemy);

		player = new Player();
		player.screenCenter();
		player.x += -350 - player.width;
		characters.add(player);
	}

	function addProjectiles():Void
	{
		projectilesManager = new ProjectileManager();
		add(projectilesManager);

		particlesManager = new ParticleManager();
		add(particlesManager);
	}

	function addHUD():Void
	{
		hud = new HUD();
		add(hud);

		enemy.hudBar = hud.enemyStats;
		player.hudBar = hud.playerStats;
	}

	override public function create()
	{
		super.create();

		final offset:Int = Std.int(9 * Main.pixel_mult / 2) * -1;
		FlxG.mouse.load('assets/images/ui/reticle.png', Main.pixel_mult, offset, offset);

		addStage();
		addCharacters();
		addProjectiles();
		addHUD();

		FlxG.sound.playMusic('assets/music/battle_theme.mp3', 0.3);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		for (character in characters.members)
			character.hudBar.camera.alpha = (character.overlaps(character.hudBar) ? 0.4 : 1);

		FlxG.overlap(characters, projectilesManager, (victim:BaseCharacter, projectile:BaseProjectile) ->
		{
			final attacker:BaseCharacter = projectile.parent;

			if (attacker != victim)
			{
				if (!victim.stunned)
				{
					attacker.magic += projectile.magicGain;

					victim.magic += projectile.magicGain / 2;
					victim.hurt(projectile.damage, projectile);
				}

				projectile.kill();

				switch (projectile.type)
				{
					case 'spear':
						var sparks:Sparks = cast particlesManager.getNewParticle('sparks');
						sparks.init(projectile.x + (projectile.width - sparks.width) / 2, projectile.y + (projectile.height - sparks.height) / 2);
					case 'prism':
						if (!victim.stunned && victim.speed_mult == 1)
						{
							victim.color = 0xff5bbbff;
							victim.speed_mult = 0.4;

							FlxTimer.wait(1, () ->
							{
								victim.color = 0xffffffff;
								victim.speed_mult = 1;
							});
						}
				}
			}
		});
	}

	override function destroy():Void
	{
		super.destroy();

		FlxG.mouse.unload();
		current = null;
	}

	public function endBattle():Void
	{
		FlxG.sound.music.stop();

		var winner:BaseCharacter = (player.stunned ? enemy : player);

		winner.velocity.set();
		winner.specialAnim('idle', 1);
		winner.acceptInput = false;
		winner.canMove = false;
		winner.flipX = winner == enemy;

		FlxTimer.wait(1, () -> winner.specialAnim('cheer', 9999));
		FlxTimer.wait(3, () ->
		{
			FlxG.cameras.fade(FlxColor.BLACK, 1, false, () -> FlxG.switchState(new MainMenu()));
		});
	}
}
