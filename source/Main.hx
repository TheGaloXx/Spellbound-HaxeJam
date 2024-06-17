package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.sound.FlxSound;
import openfl.display.Sprite;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import states.SelectionState;
import states.StartScreen;
#if !debug
import haxe.Log;
import haxe.PosInfos;
#end

class Main extends Sprite
{
	public static inline final pixel_mult:Int = 5;
	public static inline final sound_extension:String = #if html5 "mp3" #else "ogg" #end;

	public function new()
	{
		super();

		#if !debug
		Log.trace = (v:Dynamic, ?infos:PosInfos) -> {}

		#if hl
		hl.UI.closeConsole();
		#end
		#end

		FlxG.save.bind('Spellbound');
		addChild(new FlxGame(0, 0, #if SKIP_INTRO SelectionState #else StartScreen #end, 60, 60, true, false));

		FlxG.sound.volume = 0.5; // we did make everything pretty loud, sorry
		FlxG.keys.preventDefaultKeys = [TAB, UP, DOWN, LEFT, RIGHT, F1, F11, #if !debug F12 #end];
		FlxG.sound.muteKeys = [];
		FlxG.fullscreen = false;

		#if debug
		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onReset);
		#end

		#if html5
		// Thanks to my friend Sanco for this code!!! (it prevents the context menu from popping up when right clicking)
		js.Syntax.code("document.addEventListener('contextmenu', (ev) => { ev.preventDefault(); })");
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
			type_snd.loadEmbedded('assets/sounds/type.$sound_extension');
		}
		FlxG.sound.list.add(type_snd);

		type_snd.stop();
		type_snd.volume = volume;
		type_snd.play(true, 20);
	}

	public static function sound(name:String, volume:Float = 1):FlxSound
	{
		return FlxG.sound.play('assets/sounds/$name.$sound_extension');
	}
	/*
	 *
	 * 
	 * 
	 */
	/* Too late to use this...
		public static inline function midPoint(staticSprite:FlxObject, toMoveSprite:FlxObject, axes:AxesType):Float
		{
			return switch (axes)
			{
				case X:
					staticSprite.x + (staticSprite.width - toMoveSprite.width) / 2;
				case Y:
					staticSprite.y + (staticSprite.height - toMoveSprite.height) / 2;
			};
		}
	 */
}
