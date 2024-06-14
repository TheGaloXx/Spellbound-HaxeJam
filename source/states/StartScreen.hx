package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.input.mouse.FlxMouseEvent;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class StartScreen extends FlxState
{
	override public function create()
	{
		super.create();

		var text = new FlxText(0, 100, 0, 'Game made for', 32);
		text.active = false;
		text.screenCenter(X);
		add(text);

		var logo = new FlxSprite();
		logo.loadGraphic('assets/images/menu/haxejam.png');
		logo.setGraphicSize(logo.width * 0.75);
		logo.updateHitbox();
		logo.screenCenter();
		logo.active = false;
		logo.antialiasing = true;
		add(logo);

		FlxTimer.wait(1, () ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 3, false, () -> FlxG.switchState(new MainMenu()));
		});
	}

	override public function update(elapsed:Float)
	{
		// super.update(elapsed);
	}
}
