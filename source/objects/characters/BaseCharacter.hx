package objects.characters;

import flixel.FlxSprite;
import flixel.util.FlxTimer;

using StringTools;

class BaseCharacter extends FlxSprite
{
	private inline static final base_speed:Float = 300;

	private var timer:FlxTimer = null;

	public var speed_mult:Float = 1;
	public var canMove:Bool = true;
	public var acceptInput:Bool = true;

	public var speed(get, default):Float;

	function get_speed():Float
	{
		return base_speed * speed_mult;
	}

	public function new(path:String)
	{
		super();

		loadGraphic('assets/images/characters/$path.png', true, 16, 16, false, path + '_WIZARD');
		animation.add('idle', [0], 0, false);
		// animation.add('idle-blink', [1], 0, false);
		animation.add('attack', [2, 3], 12, false);
		animation.add('hurt', [4], 0, false);
		animation.add('cheer', [5, 6], 6, true);
		animation.add('walk', [7, 8, 9, 10, 11, 9], 12, true);
		animation.add('cast', [12, 13, 14, 15], 12, false);
		animation.add('dead', [16], 0, false);
		animation.add('placeholder', [17], 0, false);

		playAnim('idle');

		setGraphicSize(width * Main.pixel_mult);
		updateHitbox();

		timer = new FlxTimer();
	}

	private function playAnim(name:String, force:Bool = false, frame:Int = 0):Void
	{
		if (animation.exists(name))
			animation.play(name, force, false, frame);
		else
			animation.play('placeholder');
	}

	private function specialAnim(name:String, time:Float = 0.3):Void
	{
		playAnim(name, true);

		canMove = false;
		acceptInput = false;
		velocity.set();

		timer.start(time, (_) ->
		{
			canMove = true;
			acceptInput = true;
			playAnim('idle');
		});
	}
}
