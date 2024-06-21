package states.substates;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;

class CreditsSubState extends FlxSubState
{
	var bg:FlxBackdrop;

	public function new(bg:FlxBackdrop)
	{
		super(0xDC000000);

		this.bg = bg;
	}

	override function create():Void
	{
		super.create();

		var credits:String = 'Spellbound made by TheGalo X & GlassGuy_\n\n'
			+ 'Programming & music - TheGalo X\nArtwork & music - GlassGuy_\n\n\n'
			+ 'SFX:\n\n'
			+ 'Universal UI Soundpack\nCreated and distributed by Nathan Gibson\n(nathangibson.myportfolio.com)\nCreation date: 27/9/2021\n\n'
			+ 'Retro Falling Down SFX\n(pixabay.com/sound-effects/retro-falling-down-sfx-85575)\n\n'
			+ 'MIXKIT\n(mixkit.co/free-sound-effects/game)';

		var text = new FlxText(0, 0, FlxG.width, credits, 26);
		text.active = false;
		text.autoSize = false;
		text.alignment = CENTER;
		text.screenCenter();
		add(text);

		var exit = Main.makeButton('Go back', () ->
		{
			close();
			Main.sound('exit', 0.3);
		});
		exit.setPosition(50, 50);
		add(exit);
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
		bg.update(elapsed);
	}
}
