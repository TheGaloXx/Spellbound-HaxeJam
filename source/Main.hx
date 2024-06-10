package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static inline final pixel_mult:Int = 5;

	public function new()
	{
		super();

		FlxG.save.bind('Spellbound');
		addChild(new FlxGame(0, 0, PlayState, 60, 60, true, false));
	}
}
