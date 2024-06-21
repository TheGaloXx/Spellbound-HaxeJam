package states.substates;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import haxe.Json;
import states.SettingsState.OptionSprite;

using StringTools;

class ControlsSubState extends FlxSubState
{
	private var parent:OptionSprite;

	public static var newControls:Dynamic;

	public function new(sprite:OptionSprite)
	{
		super(0xcf000000);

		this.parent = sprite;
	}

	private var boxes:FlxTypedGroup<FlxText>;
	private var replacing:FlxText = null;
	private var alreadySetKeys:Array<FlxKey> = [];

	override function create():Void
	{
		super.create();

		var exit = Main.makeButton('Save and exit', () ->
		{
			if (newControls != null)
			{
				FlxG.save.data.controls = newControls;
				FlxG.save.flush();

				Controls.set(newControls);
			}

			close();
			Main.sound('exit', 0.3);
		});
		exit.setPosition(50, FlxG.height - exit.height - 50);
		add(exit);

		var text = new FlxText(0, 25, FlxG.width, 'Click a control, then press a key to set a keybind\n(Press ESCAPE to cancel)', 32);
		text.autoSize = false;
		text.alignment = CENTER;
		text.active = false;
		add(text);

		boxes = new FlxTypedGroup<FlxText>();
		add(boxes);

		final _:Dynamic = FlxG.save.data.controls;

		newControls = Json.parse(Json.stringify(_));

		var height:Float = 0;
		var spacing:Float = 30;
		for (i => curOption in [
			'Move left: ${_.left}',
			'Move down: ${_.down}',
			'Move up: ${_.up}',
			'Move right: ${_.right}',
			'Cast spell: ${_.spell}'
		])
		{
			var control = new FlxText(0, 25, 300, curOption, 32);
			control.autoSize = false;
			control.alignment = CENTER;
			control.active = false;
			control.screenCenter(X);
			control.ID = i;
			boxes.add(control);

			height += control.height;
		}

		height += spacing * (boxes.length - 1);

		var startY:Float = (FlxG.height - height) / 2;
		var currentY:Float = startY;

		for (sprite in boxes)
		{
			sprite.y = currentY;
			currentY += sprite.height + spacing;
		}

		for (i in Reflect.fields(_))
		{
			final field = Reflect.field(_, i);
			alreadySetKeys.push(FlxKey.fromString(field));
		}

		Main.sound('confirm', 0.7);
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (replacing == null)
		{
			if (FlxG.keys.justPressed.ESCAPE)
			{
				Main.sound('exit', 0.3);

				newControls = null;
				close();
				return;
			}

			if (FlxG.mouse.justPressed)
			{
				for (member in boxes.members)
				{
					if (FlxG.mouse.overlaps(member))
					{
						Main.sound('Coffee2', 0.3);

						FlxFlicker.flicker(member, 9999999999);
						replacing = member;
						break;
					}
				}
			}
		}
		else
		{
			if (FlxG.keys.justPressed.ANY)
				checkForNewKey();
		}
	}

	private static final blockedKeys:Array<FlxKey> = [
		FlxKey.ESCAPE, FlxKey.TAB, FlxKey.WINDOWS, FlxKey.MENU, FlxKey.PRINTSCREEN, FlxKey.BREAK, FlxKey.SHIFT, FlxKey.CONTROL, FlxKey.ALT, FlxKey.CAPSLOCK,
		FlxKey.NUMLOCK, FlxKey.SCROLL_LOCK, FlxKey.PAGEUP, FlxKey.PAGEDOWN, FlxKey.HOME, FlxKey.END, FlxKey.INSERT, FlxKey.DELETE, FlxKey.F1, FlxKey.F2,
		FlxKey.F3, FlxKey.F4, FlxKey.F5, FlxKey.F6, FlxKey.F7, FlxKey.F8, FlxKey.F9, FlxKey.F10, FlxKey.F11, FlxKey.F12, FlxKey.NUMPADMINUS,
		FlxKey.NUMPADPLUS, FlxKey.NUMPADPERIOD, FlxKey.NUMPADMULTIPLY, FlxKey.NUMPADSLASH
	];

	private function checkForNewKey():Void
	{
		final key:FlxKey = FlxG.keys.firstJustPressed();

		if (key == ESCAPE)
		{
			Main.sound('Coffee1', 0.3);

			FlxFlicker.stopFlickering(replacing);
			replacing = null;

			return;
		}

		if (key != -1 && !blockedKeys.contains(key) && !alreadySetKeys.contains(key))
		{
			// to remove the old key from the keys array, take the current text, and get the key name at the end of it
			var split = FlxKey.fromString(replacing.text.split(': ')[1]);
			alreadySetKeys.remove(split);

			// split the text by ': ' (example: "Move left: A" -> ["Move left", "A"])
			var split:Array<String> = replacing.text.split(':');
			replacing.text = split[0] + ': ' + key.toString();
			Reflect.setField(newControls, split[0].split(' ')[1], key.toString()); // then save it to the new controls but keeping only the direction

			trace('NEW KEYBINDS: ', newControls.left, newControls.down, newControls.up, newControls.right, newControls.spell);

			alreadySetKeys.push(key);
			FlxFlicker.stopFlickering(replacing);
			replacing = null;

			Main.sound('confirm', 0.85);
		}
	}
}
