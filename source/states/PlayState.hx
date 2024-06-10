package states;

import flixel.FlxState;
import objects.Player;

class PlayState extends FlxState
{
	private var player:Player;

	override public function create()
	{
		super.create();

		player = new Player();
		add(player);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
