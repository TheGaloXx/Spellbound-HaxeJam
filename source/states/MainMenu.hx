package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.input.keyboard.FlxKey;
import flixel.input.mouse.FlxMouseEvent;
import flixel.text.FlxBitmapText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxTimer;

class MainMenu extends FlxState
{
	private final code:Array<FlxKey> = [P, L, A, Y];
	private final curCode:Array<FlxKey> = [];
	private var play:FlxBitmapText;

	override public function create()
	{
		super.create();

		var bg = new FlxBackdrop('assets/images/menu/background_scroll.png');
		bg.setGraphicSize(bg.width * 2);
		bg.updateHitbox();
		bg.velocity.set(70, 70);
		add(bg);

		var logo = new FlxSprite();
		logo.loadGraphic('assets/images/menu/logo.png');
		logo.setGraphicSize(logo.width * 2);
		logo.updateHitbox();
		logo.screenCenter();
		logo.active = false;
		add(logo);

		addLogoBop(logo);

		var credits = new FlxButton(50, 0, 'Credits', () ->
		{
			FlxMouseEvent.remove(logo);

			var substate = new CreditsSubState(bg);
			substate.closeCallback = () -> addLogoBop(logo);
			openSubState(substate);
		});
		credits.setGraphicSize(credits.width * 2);
		credits.updateHitbox();
		credits.label.setGraphicSize(credits.label.width * 2);
		credits.label.updateHitbox();
		credits.y = FlxG.height - credits.height - 50;
		add(credits);

		var help = new FlxBitmapText(0, 0, '(Type "play" to start playing!)');
		help.active = false;
		help.scale.set(3, 3);
		help.updateHitbox();
		help.screenCenter(X);
		add(help);

		play = new FlxBitmapText(0, 0, '_ _ _ _');
		play.active = false;
		play.scale.set(6, 6);
		play.updateHitbox();
		play.screenCenter(X);
		play.y = FlxG.height - play.height - 20;
		add(play);

		help.y = play.y - help.height - 10;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ANY)
		{
			var key:FlxKey = FlxG.keys.firstJustPressed();

			if (code[0] == key)
			{
				curCode.push(code[0]);
				code.shift();

				var newText:String = '';

				for (i in curCode)
				{
					newText += Std.string(i) + ' ';

					trace(i, curCode.length - 1, code.length - curCode.length);
				}

				for (i in 0...4 - curCode.length)
				{
					newText += '_ ';
				}

				play.text = newText;

				Main.typeSound();

				if (code.length <= 0)
				{
					FlxG.sound.play('assets/sounds/confirm.mp3');
					FlxTimer.wait(1, () ->
					{
						FlxG.switchState(new SelectionState());
					});
				}
			}
		}
	}

	function addLogoBop(logo:FlxSprite):Void
	{
		FlxMouseEvent.add(logo, (spr:FlxSprite) ->
		{
			FlxTween.cancelTweensOf(spr.scale);

			var scaleX:Float = spr.width / spr.frameWidth;
			var scaleY:Float = spr.height / spr.frameHeight;

			spr.scale.set(scaleX * 1.05, scaleY * 1.05);
			FlxTween.tween(spr.scale, {x: scaleX, y: scaleY}, 0.5, {ease: FlxEase.elasticOut});
		}, null, null, null, null, true, false);
	}
}
