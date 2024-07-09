package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.input.mouse.FlxMouseEvent;
import flixel.sound.FlxSound;
import flixel.ui.FlxButton;
import openfl.display.Sprite;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import scripts.ScriptHandler;
import states.SettingsState;
import states.StartScreen;
#if !debug
import haxe.Log;
import haxe.PosInfos;
#end
#if SKIP_INTRO
import states.SelectionState;
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

		ScriptHandler.init();

		FlxG.save.bind('Spellbound');
		addChild(new FlxGame(0, 0, #if SKIP_INTRO SelectionState #else StartScreen #end, 60, 60, true, false));
		SettingsState.init();

		FlxG.sound.volume = 0.5; // we did make everything pretty loud, sorry
		FlxG.keys.preventDefaultKeys = [ESCAPE, TAB, UP, DOWN, LEFT, RIGHT, F1, #if !debug F12 #end];
		FlxG.sound.muteKeys = [];
		FlxG.mouse.visible = true;
		FlxG.signals.preStateCreate.add(preStateCreate);
		FlxG.fixedTimestep = false;

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
		if (!FlxG.save.data.sfxEnabled)
			volume = 0;

		if (!type_snd?.exists)
		{
			type_snd = new FlxSound();
			type_snd.loadEmbedded('assets/sounds/$sound_extension/type.$sound_extension');
		}
		FlxG.sound.list.add(type_snd);

		type_snd.stop();
		type_snd.volume = volume;
		type_snd.play(true, 20);
	}

	public static function sound(name:String, volume:Float = 1):FlxSound
	{
		if (!FlxG.save.data.sfxEnabled)
			volume = 0;

		return FlxG.sound.play('assets/sounds/$sound_extension/$name.$sound_extension', volume);
	}

	public static function music(name:String, volume:Float):Void
	{
		if (!FlxG.save.data.musicEnabled)
			volume = 0;

		FlxG.sound.playMusic('assets/music/$sound_extension/$name.$sound_extension', volume);
	}

	public static function makeButton(text:String, callback:Void->Void):FlxButton
	{
		var button = new FlxButton(0, 0, text, callback);
		button.setGraphicSize(button.width * 2);
		button.updateHitbox();
		button.label.setGraphicSize(button.label.width * 2);
		button.label.updateHitbox();

		return button;
	}

	public inline static function changeFPS(cap:Int)
	{
		if (cap > FlxG.drawFramerate)
		{
			FlxG.updateFramerate = cap;
			FlxG.drawFramerate = cap;
		}
		else
		{
			FlxG.drawFramerate = cap;
			FlxG.updateFramerate = cap;
		}
	}

	function preStateCreate(state:FlxState):Void
	{
		FlxMouseEvent.removeAll();
		ScriptHandler.clean();
	}
}
