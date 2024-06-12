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
import objects.ui.*;

class PlayState extends FlxState
{
	public static var current:PlayState = null;

	private var bg:FlxSprite;

	public var characters:FlxTypedGroup<BaseCharacter>;

	private var player:Player;
	private var enemy:Enemy;

	public var hud:HUD;

	public var projectilesManager:ProjectileManager;

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

		enemy = new Enemy();
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
	}

	function addHUD():Void
	{
		hud = new HUD();
		add(hud);
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
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.overlap(characters, projectilesManager, (character:BaseCharacter, projectile:BaseProjectile) ->
		{
			if (projectile.parent != character)
			{
				character.hurt(projectile.damage, projectile);
				projectile.kill();
			}
		});
	}

	override function destroy():Void
	{
		super.destroy();

		FlxG.mouse.unload();
		FlxG.mouse.cursor.smoothing = true;
		current = null;
	}

	public function endBattle():Void
	{
		var winner:BaseCharacter = (player.stunned ? enemy : player);

		winner.acceptInput = false;
		winner.canMove = false;

		FlxTimer.wait(1, () -> winner.specialAnim('cheer', 9999));
		FlxTimer.wait(3, () ->
		{
			FlxG.cameras.fade(FlxColor.BLACK, 1, false, () -> FlxG.switchState(new MainMenu()));
		});
	}
}
