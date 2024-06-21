package states.substates;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import objects.characters.BaseCharacter;

using StringTools;

class SuperSubState extends FlxSubState
{
	private static final screenWidth:Float = FlxG.width / Main.pixel_mult / 2;
	private static final screenHeight:Float = FlxG.height / Main.pixel_mult / 2;

	private var character:BaseCharacter;
	private var point:FlxObject;
	private var timeText:FlxText;
	private var spellText:FlxText;
	private var time:Float = 10;
	private var availableAttacks:Array<String> = [];
	private var transitioning:Bool = false;
	private var isAI:Bool;

	public var successfull:Bool = false;
	public var type:String;

	public function new(character:BaseCharacter, point:FlxObject, isAI:Bool)
	{
		super();

		this.character = character;
		this.point = point;
		this.isAI = isAI;
	}

	override function create():Void
	{
		super.create();

		if (!isAI)
		{
			var bg = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
			bg.alpha = 0.4;
			bg.scale.set(FlxG.width, FlxG.height);
			bg.updateHitbox();
			bg.setPosition(point.x - bg.width / 2, point.y - bg.height / 2);
			bg.active = false;
			add(bg);
		}

		character.specialAnim('cast', 9999);

		var optionsText:String = '';
		if (character.hudBar.habilities[0].animation.curAnim.name == 'on')
		{
			var attackTitle:String = SelectionState.habilitiesJSON.get(character.build.super1).title;
			optionsText += attackTitle + '\n';
			availableAttacks.push(attackTitle.toUpperCase() /*.replace(' ', '') */);
		}
		if (character.hudBar.habilities[1].animation.curAnim.name == 'on')
		{
			var attackTitle:String = SelectionState.habilitiesJSON.get(character.build.super2).title;
			optionsText += attackTitle + '\n';
			availableAttacks.push(attackTitle.toUpperCase() /*.replace(' ', '') */);
		}

		if (!isAI)
		{
			timeText = new FlxText(point.x - 300, point.y - 140, 600, '', 24);
			timeText.active = false;
			timeText.autoSize = false;
			timeText.alignment = CENTER;
			add(timeText);

			var options = new FlxText(point.x - 250, point.y - 140, 0, 'OPTIONS:\n$optionsText', 12);
			options.active = false;
			add(options);

			spellText = new FlxText(0, 0, 600, '_', 24);
			spellText.active = false;
			spellText.autoSize = false;
			spellText.alignment = CENTER;
			spellText.setPosition(timeText.x, timeText.y + 240);
			add(spellText);
		}

		FlxG.camera.shake(0.0005, 9999999999999999);

		if (isAI)
		{
			FlxTimer.wait(FlxG.random.float(1, 4), () ->
			{
				FlxG.camera.stopShake();
				transitioning = true;
				successfull = true;
				type = FlxG.random.getObject(availableAttacks).toLowerCase();

				FlxTimer.wait(0.5, () -> close());
			});
		}
	}

	private var backspaceTime:Float = 0;
	private var deleteTiming:Float = 0;

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		@:privateAccess
		character.updateAnimation(elapsed);

		#if debug
		if (FlxG.mouse.wheel != 0)
			FlxG.camera.zoom += (FlxG.mouse.wheel / 500);
		#end

		if (!isAI)
		{
			if (!transitioning)
			{
				time -= elapsed;
				if (time <= 0)
				{
					transitioning = true;
					FlxG.camera.stopShake();
					close();
					return;
				}

				timeText.text = 'CAST YOUR SPELL\n' + FlxStringUtil.formatTime(time, true);

				if (FlxG.keys.justPressed.ANY)
					typeInput();

				if (FlxG.keys.pressed.BACKSPACE)
					backspaceTime += elapsed;
				if (FlxG.keys.justReleased.BACKSPACE)
				{
					backspaceTime = 0;
					deleteTiming = 0;
				}

				if (backspaceTime >= 0.4)
				{
					deleteTiming += elapsed;

					if (deleteTiming >= 0.05)
					{
						deleteTiming = 0;
						typeInput(true);
					}
				}
			}
		}
	}

	var curCode:Array<FlxKey> = [];

	private static final allowedKeys:Array<FlxKey> = [
		A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z, SPACE, BACKSPACE
	];

	private var parts:Array<String> = [];

	function typeInput(holdingBackspace:Bool = false):Void
	{
		if (holdingBackspace && curCode.length > 0)
		{
			curCode.pop();
			spellText.text = spellText.text.substring(0, spellText.text.length - 1);
			return;
		}

		var key:FlxKey = FlxG.keys.firstJustPressed();

		if (!allowedKeys.contains(key))
			return;

		if (key == BACKSPACE)
		{
			Main.sound('error', 0.5);

			if (curCode.length > 0)
			{
				curCode.pop();
				spellText.text = spellText.text.substring(0, spellText.text.length - 1);
			}

			return;
		}

		if (curCode.length >= 30 || (curCode.length <= 0 && key == SPACE) || (curCode[curCode.length - 1] == SPACE && key == SPACE))
		{
			Main.sound('error', 0.5);
			return;
		}

		Main.typeSound();

		curCode.push(key);

		var string:String = '';
		for (i in curCode)
		{
			if (i == SPACE)
				string += ' ';
			else
				string += i.toString().toUpperCase();
		}

		spellText.text = string;

		if (availableAttacks.contains(string))
		{
			FlxG.camera.stopShake();
			transitioning = true;
			successfull = true;
			type = string.toLowerCase();

			Main.sound('confirm', 0.85);
			FlxTimer.wait(0.5, () -> close());
		}
	}
}
