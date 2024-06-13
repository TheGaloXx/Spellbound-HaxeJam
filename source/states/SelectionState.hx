package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.input.mouse.FlxMouseEvent;
import flixel.math.FlxPoint;
import flixel.text.FlxBitmapText;

class SelectionState extends FlxState
{
	private var levelText:FlxBitmapText;
	private var portraits:FlxSpriteGroup;

	public static var curLevel:Int = 3;

	override function create():Void
	{
		super.create();

		var text = new FlxBitmapText(0, 20, 'Select your habilities');
		text.scale.set(5, 5);
		text.updateHitbox();
		text.screenCenter(X);
		text.active = false;
		add(text);

		var red = new FlxSprite();
		red.loadGraphic('assets/images/characters/red.png', true, 16, 16, false, 'red_WIZARD');
		red.animation.add('idle', [0], 0, false);
		red.animation.play('idle');
		red.setGraphicSize(red.width * Main.pixel_mult * 2);
		red.updateHitbox();
		red.screenCenter(Y);
		red.x = FlxG.width - red.width - 150;
		red.flipX = true;
		red.active = false;
		add(red);

		levelText = new FlxBitmapText(0, 0, 'AI level: $curLevel');
		levelText.scale.set(4, 4);
		levelText.updateHitbox();
		levelText.active = false;
		levelText.setPosition(red.x, red.y + red.height + 5);
		add(levelText);

		FlxMouseEvent.add(red, increaseAIlevel, null, null, null, null, true, false);
		FlxMouseEvent.add(levelText, increaseAIlevel, null, null, null, null, true, false);

		portraits = new FlxSpriteGroup();
		add(portraits);

		final position:FlxPoint = FlxPoint.get();
		for (i in 0...6)
		{
			var portrait = new FlxSprite();
			portrait.loadGraphic('assets/images/attack_portraits.png', true, 32, 32);
			portrait.animation.add('idle', [i], 0, false);
			portrait.animation.play('idle');
			portrait.active = false;
			portrait.setGraphicSize(portrait.width * Main.pixel_mult);
			portrait.updateHitbox();
			portrait.setPosition(position.x, position.y);
			portraits.add(portrait);

			position.x += portrait.width;

			if (i == 2)
				position.set(0, portrait.height * 2);
		}
		position.put();

		portraits.screenCenter();
		portraits.x -= 200;
	}

	function increaseAIlevel(spr:FlxSprite):Void
	{
		curLevel++;

		if (curLevel > 10)
			curLevel = 1;

		levelText.text = 'AI level: $curLevel';
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.Y)
			FlxG.switchState(new PlayState());
	}
}
