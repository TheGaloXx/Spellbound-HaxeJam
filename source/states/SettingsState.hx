package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.input.mouse.FlxMouseEvent;
import flixel.text.FlxText;
import states.substates.ControlsSubState;

class SettingsState extends FlxState
{
	public static function init():Void
	{
		FlxG.save.data.fps ??= 60;
		FlxG.save.data.fullscreen ??= false;
		FlxG.save.data.controls ??= {
			left: "A",
			down: "S",
			up: "W",
			right: "D",
			spell: "SPACE"
		}
		FlxG.save.data.musicEnabled ??= true;
		FlxG.save.data.sfxEnabled ??= true;
		FlxG.save.data.autopause ??= true;

		FlxG.save.flush();

		applySettings();
	}

	public static function applySettings():Void
	{
		#if html5
		Main.changeFPS(60);
		FlxG.fullscreen = false;
		#else
		Main.changeFPS(FlxG.save.data.fps);
		FlxG.fullscreen = FlxG.save.data.fullscreen;
		#end

		Controls.set(FlxG.save.data.controls);
		if (FlxG.sound.music != null && FlxG.sound.music.playing)
		{
			FlxG.sound.music.fadeTween.cancel();

			if (!FlxG.save.data.musicEnabled)
			{
				FlxG.sound.music.volume = 0;
			}
			else
				FlxG.sound.music.volume = 0.5;
		}
		FlxG.autoPause = FlxG.save.data.autopause;
	}

	final allSettings:Array<String> = [
		#if !html5
		'fps', 'fullscreen',
		#end
		'controls',
		'musicEnabled',
		'sfxEnabled',
		'autopause'
	];

	function saveSettings():Void
	{
		for (i in options)
		{
			if (i.variable != 'controls')
				Reflect.setField(FlxG.save.data, i.variable, i.data);
		}

		FlxG.save.flush();

		applySettings();
	}

	private var options:FlxTypedGroup<OptionSprite>;
	private var bg:FlxBackdrop;

	override function create():Void
	{
		super.create();

		bg = new FlxBackdrop('assets/images/menu/background_scroll.png');
		bg.setGraphicSize(bg.width * 2);
		bg.updateHitbox();
		bg.velocity.set(70, 70);
		bg.setPosition(MainMenu.scrollCords[0], MainMenu.scrollCords[1]);
		add(bg);

		var exit = Main.makeButton('Go back', () ->
		{
			FlxG.switchState(new MainMenu());
			Main.sound('exit', 0.3).persist = true;
		});
		exit.setPosition(50, 50);
		add(exit);

		var apply = Main.makeButton('Apply changes', () ->
		{
			saveSettings();
			Main.sound('confirm', 0.85);
		});
		apply.setPosition(FlxG.width - apply.width - 50, FlxG.height - apply.height - 50);
		add(apply);

		options = new FlxTypedGroup<OptionSprite>();
		add(options);

		var height:Float = 0;
		var spacing:Float = 15;

		for (option in allSettings)
		{
			var sprite = new OptionSprite(option);
			sprite.screenCenter(X);
			options.add(sprite);

			if (option == 'controls')
			{
				sprite.onClick = () ->
				{
					ControlsSubState.newControls = null;

					for (member in options.members)
						member.removeEvent();

					var substate = new ControlsSubState(sprite);
					substate.closeCallback = () ->
					{
						for (member in options.members)
							member.addEvent();
					}
					openSubState(substate);
				}
			}

			height += sprite.height;
		}

		height += spacing * (options.length - 1);

		var startY:Float = (FlxG.height - height) / 2;
		var currentY:Float = startY;

		for (sprite in options)
		{
			sprite.y = currentY;
			currentY += sprite.height + spacing;
		}
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		MainMenu.scrollCords = [bg.x, bg.y];
	}
}

class OptionSprite extends FlxSpriteGroup
{
	public var box:FlxSprite;
	public var text:FlxText;
	public var variable:String;
	public var onClick:Void->Void;
	public var data:Dynamic;

	public function new(variable:String)
	{
		super();

		this.variable = variable;

		box = new FlxSprite();
		box.loadGraphic('assets/images/menu/settings_boxes.png', true, 16, 16);
		box.setGraphicSize(box.width * Main.pixel_mult);
		box.updateHitbox();
		box.animation.add('checkbox', [0, 1], 0, false);
		box.animation.add('thing', [2], 0, false, true);
		box.active = false;
		add(box);

		text = new FlxText(box.width + 10, 0, 300, '', 24);
		text.autoSize = false;
		text.alignment = CENTER;
		text.active = false;
		text.y = (box.height - text.height) / 2;
		add(text);

		data = Reflect.field(FlxG.save.data, variable);
		if (Std.isOfType(data, Bool))
			box.animation.play('checkbox');
		else
			box.animation.play('thing');

		text.text = switch (variable)
		{
			case 'fps': 'FPS: $data';
			case 'fullscreen': 'Fullscreen';
			case 'controls': 'Controls';
			case 'musicEnabled': 'Music';
			case 'sfxEnabled': 'Sound effects';
			case 'autopause': 'Pause on focus lost';
			default: '_';
		}
		if (variable != 'fps' && variable != 'controls')
			box.animation.curAnim.curFrame = (cast(data, Bool) == true ? 1 : 0);

		addEvent();
	}

	public function callback(sprite:FlxSprite):Void
	{
		if (variable != 'controls')
		{
			if (Std.isOfType(data, Bool))
				data = !data;
			else
			{
				final possibleFPS:Array<Int> = [30, 50, 60, 90, 120, 144, 180];
				var i:Int = possibleFPS.indexOf(data) + 1;
				if (i > possibleFPS.length - 1)
					i = 0;
				data = possibleFPS[i];
			}

			if (variable == 'fps')
				text.text = 'FPS: ' + data;
			else
				box.animation.curAnim.curFrame = (cast(data, Bool) == true ? 1 : 0);
		}

		Main.sound('Coffee2', 0.3);

		if (onClick != null)
			onClick();
	}

	public function addEvent():Void
	{
		FlxMouseEvent.add(this, callback, null, null, null, false, true, false);
	}

	public function removeEvent():Void
	{
		FlxMouseEvent.remove(this);
	}
}
