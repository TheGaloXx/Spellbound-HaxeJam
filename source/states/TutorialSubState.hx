package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.tweens.FlxTween;

class TutorialSubState extends FlxSubState
{
	private var tutorial:FlxSprite;

	public var opened:Bool = false;

	override function create():Void
	{
		super.create();

		opened = true;

		tutorial = new FlxSprite().loadGraphic('assets/images/menu/tutorial.png');
		tutorial.active = false;
		tutorial.alpha = 0;
		tutorial.screenCenter();
		add(tutorial);

		Main.sound('confirm', 0.7);
		FlxTween.tween(tutorial, {alpha: 1}, 0.25);
	}

	override function update(elapsed:Float):Void
	{
		// super.update(elapsed);

		if (FlxG.keys.anyJustPressed([ESCAPE, SPACE, BACKSPACE]) || FlxG.mouse.justPressed)
		{
			Main.sound('exit', 0.3);
			close();
		}
	}
}
