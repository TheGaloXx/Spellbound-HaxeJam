package states;

import flixel.FlxSprite;
import flixel.FlxState;
import objects.*;
import objects.characters.*;
import objects.ui.*;

class PlayState extends FlxState
{
	private var bg:FlxSprite;

	private var player:Player;
	private var enemy:Enemy;

	private var hud:HUD;

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
		enemy = new Enemy();
		enemy.screenCenter();
		enemy.x += 350;
		add(enemy);

		player = new Player();
		add(player);
	}

	function addHUD():Void
	{
		hud = new HUD();
		add(hud);
	}

	override public function create()
	{
		super.create();

		addStage();
		addCharacters();
		addHUD();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
