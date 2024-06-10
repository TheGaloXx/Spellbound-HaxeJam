package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;
import states.MainMenu;

class Main extends Sprite
{
	public static inline final pixel_mult:Int = 5;

	public function new()
	{
		super();

		FlxG.save.bind('Spellbound');
		addChild(new FlxGame(0, 0, MainMenu, 60, 60, true, false));

		FlxG.keys.preventDefaultKeys = [TAB, UP, DOWN, LEFT, RIGHT, F11, #if !debug F12 #end];
	}
}
