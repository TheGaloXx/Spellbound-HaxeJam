package objects.ui;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class HUD extends FlxGroup
{
	public var timer:FlxText;
	public var playerStats:Bar;
	public var enemyStats:Bar;

	public var cam:FlxCamera;

	public function new()
	{
		super();

		cam = new FlxCamera();
		cam.bgColor = 0;
		FlxG.cameras.add(cam, false);

		playerStats = new Bar();
		playerStats.x = 50;
		playerStats.y = FlxG.height - 20 - playerStats.height;
		playerStats.camera = cam;
		add(playerStats);

		enemyStats = new Bar(true);
		enemyStats.x = FlxG.width - 21 - enemyStats.width;
		enemyStats.y = FlxG.height - 20 - enemyStats.height;
		enemyStats.camera = cam;
		add(enemyStats);

		timer = new FlxText(0, 5, FlxG.width, 'Supers allowed in: ', 28);
		timer.active = false;
		timer.autoSize = false;
		timer.alignment = CENTER;
		timer.camera = cam;
		timer.color = FlxColor.RED;
		timer.alpha = 0.4;
		add(timer);
	}
}
