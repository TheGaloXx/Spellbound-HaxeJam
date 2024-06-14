package objects.ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxBitmapText;

class HabilityDescriptionBox extends FlxSpriteGroup
{
	public var bg:FlxSprite;
	public var label:FlxBitmapText;
	public var text(default, set):String;

	public function new()
	{
		super();

		bg = new FlxSprite();
		bg.makeGraphic(1, 1);
		bg.color = 0xff212121;
		bg.active = false;
		bg.scale.x = 600;
		add(bg);

		label = new FlxBitmapText(5, 5);
		label.scale.set(3, 3);
		label.updateHitbox();
		label.active = false;
		label.autoSize = false;
		label.alignment = LEFT;
		label.fieldWidth = 200;
		add(label);

		visible = false;
	}

	override function update(elapsed:Float):Void
	{
		// super.update(elapsed);

		if (visible)
		{
			this.setPosition(FlxG.mouse.screenX, FlxG.mouse.screenY + 20);
			if (this.y > FlxG.height - height)
				this.y = FlxG.height - height;
		}
	}

	function set_text(value:String):String
	{
		if (text == value)
			return text;

		text = value;
		label.text = text;

		bg.scale.y = label.height + 10;
		bg.updateHitbox();

		return text;
	}
}
