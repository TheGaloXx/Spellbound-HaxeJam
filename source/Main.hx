package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import states.MainMenu;

class Main extends Sprite
{
	public static inline final pixel_mult:Int = 5;

	public function new()
	{
		super();

		FlxG.save.bind('Spellbound');
		addChild(new FlxGame(0, 0, MainMenu, 60, 60, true, false));

		FlxG.keys.preventDefaultKeys = [TAB, UP, DOWN, LEFT, RIGHT, F1, F11, #if !debug F12 #end];
		FlxG.sound.muteKeys = [];

		#if debug
		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onReset);
		#end
	}

	function onReset(key:KeyboardEvent):Void
	{
		if (key.keyCode == Keyboard.F4)
		{
			FlxG.resetGame();
		}
	}
}
