package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.sound.FlxSound;
import openfl.display.Sprite;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import states.StartScreen;
#if !debug
import haxe.Log;
import haxe.PosInfos;
#end

class Main extends Sprite
{
	public static inline final pixel_mult:Int = 5;

	public function new()
	{
		super();

		#if !debug
		Log.trace = (v:Dynamic, ?infos:PosInfos) -> {}
		#end

		FlxG.save.bind('Spellbound');
		addChild(new FlxGame(0, 0, StartScreen, 60, 60, true, false));

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

	public static var type_snd:FlxSound;

	public static function typeSound(volume:Float = 1.0):Void
	{
		if (!type_snd?.exists)
		{
			type_snd = new FlxSound();
			type_snd.loadEmbedded('assets/sounds/type.mp3');
		}
		FlxG.sound.list.add(type_snd);

		type_snd.stop();
		type_snd.volume = volume;
		type_snd.play(true, 20);
	}
}
