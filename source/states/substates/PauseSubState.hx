package states.substates;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class PauseSubState extends FlxSubState
{
	private var texts:FlxTypedGroup<FlxText>;

	public function new(cam:FlxCamera)
	{
		super(0xcf000000);

		this.camera = cam;
	}

	override function create():Void
	{
		super.create();

		texts = new FlxTypedGroup<FlxText>();
		add(texts);

		var height:Float = 0;
		var spacing:Float = 30;
		for (i in ['Resume', 'Restart', 'Exit to main menu'])
		{
			var text = new FlxText(0, 25, 300, i, 32);
			text.autoSize = false;
			text.alignment = CENTER;
			text.active = false;
			text.screenCenter(X);
			texts.add(text);

			height += text.height;
		}

		height += spacing * (texts.length - 1);

		var startY:Float = (FlxG.height - height) / 2;
		var currentY:Float = startY;

		for (sprite in texts)
		{
			sprite.y = currentY;
			currentY += sprite.height + spacing;
		}

		Main.sound('Coffee2', 0.3);
	}

	override function update(elapsed:Float):Void
	{
		// super.update(elapsed);

		if (FlxG.keys.anyJustPressed([ESCAPE, BACKSPACE]))
		{
			Main.sound('exit', 0.3);
			close();

			return;
		}

		if (FlxG.mouse.justPressed)
		{
			for (text in texts)
			{
				if (FlxG.mouse.overlaps(text))
				{
					switch (text.text)
					{
						case 'Resume':
							Main.sound('exit', 0.3);
							close();
						case 'Restart':
							// close();
							FlxG.sound.music.stop();
							final build = PlayState.current.build;

							var func = () -> FlxG.switchState(new PlayState(build));

							FlxG.signals.postStateSwitch.add(func);

							FlxG.switchState(new FlxState());

						case 'Exit to main menu':
							close();
							FlxG.sound.music.stop();
							FlxG.switchState(new MainMenu());
					}
				}
			}
		}
	}
}
