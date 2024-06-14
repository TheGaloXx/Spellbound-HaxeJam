package objects.ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;

class HabilityDescriptionBox extends FlxSpriteGroup
{
	public var bg:FlxSprite;
	public var label:FlxText;
	public var text(default, set):String;

	public function new()
	{
		super();

		bg = new FlxSprite();
		bg.makeGraphic(1, 1, 0xff212121);
		bg.active = false;
		bg.scale.x = 405;
		add(bg);

		label = new FlxText(5, 5, 400, '', 16);
		label.active = false;
		label.autoSize = false;
		label.alignment = LEFT;
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
