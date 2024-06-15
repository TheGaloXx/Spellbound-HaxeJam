package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.input.keyboard.FlxKey;
import flixel.input.mouse.FlxMouseEvent;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class MainMenu extends FlxState
{
	private static var alreadyTyped:Bool = false;

	private var transitioning:Bool = false;
	private final code:Array<FlxKey> = [P, L, A, Y];
	private final curCode:Array<FlxKey> = [];
	private var play:FlxText;

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
			if (!transitioning)
			{
				FlxMouseEvent.remove(logo);

				var substate = new CreditsSubState(bg);
				substate.closeCallback = () -> addLogoBop(logo);
				openSubState(substate);

				FlxG.sound.play('assets/sounds/confirm.mp3', 0.85);
			}
		});
		credits.setGraphicSize(credits.width * 2);
		credits.updateHitbox();
		credits.label.setGraphicSize(credits.label.width * 2);
		credits.label.updateHitbox();
		credits.y = FlxG.height - credits.height - 30;
		add(credits);

		if (!alreadyTyped)
		{
			var help = new FlxText(0, 0, 0, '(Type "play" to start playing!)', 24);
			help.active = false;
			help.screenCenter(X);
			add(help);

			play = new FlxText(0, 0, 0, '_ _ _ _', 50);
			play.active = false;
			play.screenCenter(X);
			play.y = FlxG.height - play.height - 20;
			add(play);

			help.y = play.y - help.height - 10;
		}
		else
		{
			var play = new FlxButton(0, 0, 'Play', () ->
			{
				transition();
			});
			play.setGraphicSize(play.width * 2);
			play.updateHitbox();
			play.label.setGraphicSize(play.label.width * 2);
			play.label.updateHitbox();
			play.screenCenter(X);
			play.y = credits.y;
			add(play);
		}

		if (FlxG.sound.music == null || !FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic('assets/music/menu_theme.mp3', 0.3);
			FlxG.sound.music.fadeIn(3, 0, 0.5);
		}

		FlxG.camera.fade(FlxColor.BLACK, 1, true);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!alreadyTyped && FlxG.keys.justPressed.ANY)
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
					alreadyTyped = true;
					transition();
				}
			}
		}
	}

	function addLogoBop(logo:FlxSprite):Void
	{
		FlxMouseEvent.add(logo, (spr:FlxSprite) ->
		{
			if (!transitioning)
			{
				FlxTween.cancelTweensOf(spr.scale);

				var scaleX:Float = spr.width / spr.frameWidth;
				var scaleY:Float = spr.height / spr.frameHeight;

				spr.scale.set(scaleX * 1.05, scaleY * 1.05);
				FlxTween.tween(spr.scale, {x: scaleX, y: scaleY}, 0.5, {ease: FlxEase.elasticOut});
			}
		}, null, null, null, false, true, false);
	}

	function transition():Void
	{
		if (transitioning)
			return;

		FlxG.sound.play('assets/sounds/confirm.mp3', 0.85);
		FlxTimer.wait(1, () ->
		{
			FlxG.switchState(new SelectionState());
		});
	}
}
