package states;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxBitmapText;
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

		var credits:String = 'Spellbound made by TheGalo X & GlassGuy_

Programming & music - TheGalo X
Artwork & music - GlassGuy_


SFX:

Universal UI Soundpack
Created and distributed by Nathan Gibson
(nathangibson.myportfolio.com)
Creation date: 27/9/2021

Retro Falling Down SFX
(pixabay.com/sound-effects/retro-falling-down-sfx-85575)';

		var text = new FlxBitmapText(0, 0, credits);
		text.scale.set(4, 4);
		text.updateHitbox();
		text.active = false;
		text.autoSize = false;
		text.alignment = CENTER;
		text.fieldWidth = Std.int(FlxG.width / 2);
		text.screenCenter();
		add(text);

		var exit = new FlxButton(50, 50, 'Go back', () ->
		{
			close();
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
