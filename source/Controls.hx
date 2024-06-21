package;

import flixel.FlxG;

class Controls
{
	public static var left:Key;
	public static var down:Key;
	public static var up:Key;
	public static var right:Key;
	public static var spell:Key;

	public static function set(data:Dynamic):Void
	{
		left = new Key(data.left);
		down = new Key(data.down);
		up = new Key(data.up);
		right = new Key(data.right);
		spell = new Key(data.spell);
	}
}

private class Key
{
	public var justPressed(get, default):Bool;
	public var pressed(get, default):Bool;

	public var justReleased(get, default):Bool;
	public var released(get, default):Bool;

	private var key:String;

	public function new(key:String)
	{
		this.key = key;
	}

	function get_justPressed():Bool
	{
		return FlxG.keys.checkStatus(FlxKey.fromString(key), JUST_PRESSED);
	}

	function get_pressed():Bool
	{
		return FlxG.keys.checkStatus(FlxKey.fromString(key), PRESSED);
	}

	function get_justReleased():Bool
	{
		return FlxG.keys.checkStatus(FlxKey.fromString(key), JUST_RELEASED);
	}

	function get_released():Bool
	{
		return FlxG.keys.checkStatus(FlxKey.fromString(key), RELEASED);
	}
}
