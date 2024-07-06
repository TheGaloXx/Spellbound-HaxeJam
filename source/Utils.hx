package;

import flixel.FlxObject;
import flixel.util.FlxAxes;

class Utils
{
	public static inline function midPoint(staticSprite:FlxObject, toMoveSprite:FlxObject, axes:FlxAxes):Float
	{
		return switch (axes)
		{
			case X:
				staticSprite.x + (staticSprite.width - toMoveSprite.width) / 2;
			case Y:
				staticSprite.y + (staticSprite.height - toMoveSprite.height) / 2;
			default:
				0;
		};
	}

	public static inline function snapToSprite(staticSprite:FlxObject, toMoveSprite:FlxObject):Void
	{
		toMoveSprite.x = Utils.midPoint(staticSprite, toMoveSprite, X);
		toMoveSprite.y = Utils.midPoint(staticSprite, toMoveSprite, Y);
	}
}
