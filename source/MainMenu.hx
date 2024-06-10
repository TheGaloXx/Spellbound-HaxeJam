package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.input.mouse.FlxMouseEvent;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;

class MainMenu extends FlxState
{
	override public function create()
	{
		super.create();

		bgColor = 0xff7f6094;

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

		FlxMouseEvent.add(logo, (spr:FlxSprite) ->
		{
			FlxTween.cancelTweensOf(spr.scale);

			var scaleX:Float = spr.width / spr.frameWidth;
			var scaleY:Float = spr.height / spr.frameHeight;

			spr.scale.set(scaleX * 1.05, scaleY * 1.05);
			FlxTween.tween(spr.scale, {x: scaleX, y: scaleY}, 0.5, {ease: FlxEase.elasticOut});
		});

		var play = new FlxButton(0, 0, 'Play', () ->
		{
			FlxG.switchState(new PlayState());
		});
		play.setGraphicSize(play.width * 2);
		play.updateHitbox();
		play.label.setGraphicSize(play.label.width * 2);
		play.label.updateHitbox();
		play.screenCenter(X);
		play.y = FlxG.height - play.height - 100;
		add(play);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
