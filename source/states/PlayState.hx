package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
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

	private var colliders:FlxTypedGroup<FlxObject>;

	private var barrier:FlxSprite;

	public var characters:FlxTypedGroup<BaseCharacter>;

	public var player:Player;
	public var enemy:Enemy;

	public var hud:HUD;

	public var projectilesManager:ProjectileManager;
	public var particlesManager:ParticleManager;
	public var build:CharacterBuild;

	override public function new(build:CharacterBuild)
	{
		super();

		this.build = build;
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

		barrier = new FlxSprite();
		barrier.loadGraphic('assets/images/barrier.png');
		barrier.setGraphicSize(barrier.width * Main.pixel_mult);
		barrier.updateHitbox();
		barrier.screenCenter();
		barrier.active = false;
		barrier.alpha = 0.5;
		barrier.blend = ADD;
		final scale = barrier.scale.clone();
		FlxTween.tween(barrier.scale, {x: scale.x * 1.2, y: scale.y * 1.01}, 0.25, {type: PINGPONG});

		colliders = new FlxTypedGroup<FlxObject>();
		add(colliders);

		for (i in 0...7)
		{
			var wall = new FlxObject();
			wall.immovable = true;
			colliders.add(wall);

			switch (i)
			{
				case 0: // left
					wall.setSize(1, FlxG.height);
					wall.setPosition(-1, 0);
				case 1: // top
					wall.setSize(FlxG.width, 1);
					wall.setPosition(0, 20);
				case 2: // floor
					wall.setSize(FlxG.width, 1);
					wall.setPosition(0, FlxG.height);
				case 3: // right
					wall.setSize(1, FlxG.height);
					wall.setPosition(FlxG.width, 0);
				case 4: // middle
					wall.setSize(5, FlxG.width);
					wall.screenCenter();
				case 5:
					wall.setSize(50, 60);
					wall.setPosition(0, 0);
				case 6:
					wall.setSize(50, 100);
					wall.setPosition(FlxG.width - wall.width, FlxG.height - wall.height);
			}
		}
	}

	function addCharacters():Void
	{
		characters = new FlxTypedGroup<BaseCharacter>();
		add(characters);

		enemy = new Enemy(SelectionState.curLevel);
		enemy.screenCenter(Y);
		enemy.x = FlxG.width;
		enemy.immovable = true;
		enemy.active = false;
		characters.add(enemy);

		player = new Player(build);
		player.screenCenter(Y);
		player.x = -player.width;
		player.immovable = true;
		player.active = false;
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
		add(barrier);
		addHUD();
		intro();

		FlxG.sound.playMusic('assets/music/battle_theme.mp3', 0.2);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.collide(characters, colliders);

		for (character in characters.members)
			character.hudBar.camera.alpha = (character.overlaps(character.hudBar) ? 0.4 : 1);

		FlxG.overlap(characters, projectilesManager, (victim:BaseCharacter, projectile:BaseProjectile) ->
		{
			final attacker:BaseCharacter = projectile.parent;

			if (attacker != victim && !attacker.dead && !victim.dead)
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
		if (FlxG.sound.music != null && FlxG.sound.music.playing)
			FlxG.sound.music.stop();

		var winner:BaseCharacter = (player.dead ? enemy : player);

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

	function intro():Void
	{
		hud.visible = false;

		FlxTween.tween(enemy, {x: FlxG.width / 2 + FlxG.width / 4 - enemy.width / 2}, 1, {
			onUpdate: (_) ->
			{
				enemy.animation.play('walk');
				@:privateAccess
				enemy.updateAnimation(FlxG.elapsed);
			},
			onComplete: (_) ->
			{
				enemy.animation.play('idle');
			}
		});

		FlxTween.tween(player, {x: FlxG.width / 4 - player.width / 2}, 1, {
			onUpdate: (_) ->
			{
				player.animation.play('walk');
				@:privateAccess
				player.updateAnimation(FlxG.elapsed);
			},
			onComplete: (_) ->
			{
				player.animation.play('idle');
			}
		});

		FlxG.camera.fade(FlxColor.BLACK, 0.5, true);
		FlxTimer.wait(2, () ->
		{
			enemy.immovable = false;
			enemy.active = true;

			player.immovable = false;
			player.active = true;

			hud.visible = true;
		});
	}
}
