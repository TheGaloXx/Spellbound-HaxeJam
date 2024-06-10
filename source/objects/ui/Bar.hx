package objects.ui;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;

class Bar extends FlxSpriteGroup
{
	public var healthBar:FlxBar;
	public var playerHealth:Float = 75;

	public function new(flip:Bool = false)
	{
		super();

		final _width:Int = 400;
		final _height:Int = 60;
		final borderSize:Int = 8;

		var border = new FlxSprite();
		border.makeGraphic(1, 1);
		border.color = FlxColor.BLACK;

		healthBar = new FlxBar(0, 0, (flip ? RIGHT_TO_LEFT : LEFT_TO_RIGHT), _width, _height, this, "playerHealth", 0, 100);
		healthBar.createFilledBar(FlxColor.GRAY, FlxColor.GREEN);
		healthBar.numDivisions = 200;

		border.scale.set(healthBar.width + borderSize, healthBar.height + borderSize);
		border.updateHitbox();
		border.setPosition((healthBar.width - border.width) / 2, (healthBar.height - border.height) / 2);
		add(border);
		add(healthBar);

		FlxTween.tween(this, {playerHealth: 0}, 1, {type: PINGPONG});
	}
}
