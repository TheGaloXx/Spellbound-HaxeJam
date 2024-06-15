package states;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

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

		var exit = new FlxButton(50, 50, 'Go back', () ->
		{
			close();
			FlxG.sound.play('assets/sounds/exit.mp3');
		});
		exit.setGraphicSize(exit.width * 2);
		exit.updateHitbox();
		exit.label.setGraphicSize(exit.label.width * 2);
		exit.label.updateHitbox();
		add(exit);
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
		bg.update(elapsed);
	}
}
