package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.input.mouse.FlxMouseEvent;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import haxe.Json;
import objects.characters.CharacterBuild;
import objects.ui.HabilityDescriptionBox;
import openfl.Assets;

class SelectionState extends FlxState
{
	public static var habilitiesJSON:Map<String, Dynamic>;

	private var habilityDescriptions:Map<String, String>;

	private var levelText:FlxText;
	private var portraits:FlxTypedSpriteGroup<BoxOutline>;
	private var selectOutline:BoxOutline;
	private var outlines:FlxTypedGroup<BoxOutline>;
	private var build:CharacterBuild;
	private var descBox:HabilityDescriptionBox;
	private var play:FlxButton;

	public static var curLevel:Int = 3;

	private function initDescriptions():Void
	{
		habilityDescriptions = new Map<String, String>();
		habilitiesJSON = new Map<String, Dynamic>();

		var finalDesc:String = '';

		for (i in ['spear', 'bottle', 'prism', 'ice', 'fire', 'light'])
		{
			var rawJson:String = Assets.getText('assets/data/$i.json');
			var json:Dynamic = Json.parse(rawJson);

			habilitiesJSON.set(json.codeName, json);

			if (['spear', 'bottle', 'prism'].contains(i))
			{
				finalDesc = '- ${json.title} -\nDamage: ${json.damage}\nCooldown: ${json.cooldown}\n\nDescription: ${json.description}';
			}
			else
			{
				finalDesc = '- ${json.title} -\nDamage: ${json.damage}\nMagic cost: ${json.cost}\nDuration: ${json.duration}\n\nDescription: ${json.description}';
			}

			habilityDescriptions.set(json.codeName, finalDesc);
		}
	}

	override function create():Void
	{
		super.create();

		initDescriptions();

		var bg = new FlxSprite();
		bg.loadGraphic('assets/images/menu/portrait_bg.png');
		bg.setGraphicSize(bg.width * Main.pixel_mult);
		bg.updateHitbox();
		bg.active = false;
		bg.setPosition(80, -230);
		add(bg);

		var text = new FlxText(0, 20, 0, 'Select your habilities', 32);
		text.screenCenter(X);
		text.active = false;
		text.borderStyle = FlxTextBorderStyle.SHADOW;
		text.borderSize = 6;
		add(text);

		var red = new FlxSprite();
		red.loadGraphic('assets/images/characters/red.png', true, 16, 16, false, 'red_WIZARD');
		red.animation.add('idle', [0], 0, false);
		red.animation.play('idle');
		red.setGraphicSize(red.width * Main.pixel_mult * 2);
		red.updateHitbox();
		red.screenCenter(Y);
		red.x = FlxG.width - red.width - 150;
		red.flipX = true;
		red.active = false;
		add(red);

		var light = new FlxSprite();
		light.loadGraphic('assets/images/menu/light.png');
		light.setGraphicSize(light.width * Main.pixel_mult * 1.2);
		light.updateHitbox();
		light.active = false;
		light.alpha = 0.25;
		light.blend = ADD;
		light.setPosition(red.x + (red.width - light.width) / 2, -50);
		add(light);

		levelText = new FlxText(red.x, red.y + red.height + 5, red.width, 'AI level: $curLevel', 16);
		levelText.autoSize = false;
		levelText.alignment = CENTER;
		levelText.active = false;
		add(levelText);

		FlxMouseEvent.add(red, increaseAIlevel, null, null, null, false, true, false);
		FlxMouseEvent.add(levelText, increaseAIlevel, null, null, null, false, true, false);

		portraits = new FlxTypedSpriteGroup<BoxOutline>();
		add(portraits);

		final position:FlxPoint = FlxPoint.get();
		for (i in 0...6)
		{
			var portrait = new BoxOutline();
			portrait.loadGraphic('assets/images/attack_portraits.png', true, 32, 32);
			portrait.animation.add('idle', [i], 0, false);
			portrait.animation.play('idle');
			portrait.active = false;
			portrait.setGraphicSize(portrait.width * Main.pixel_mult);
			portrait.updateHitbox();
			portrait.setPosition(position.x, position.y);
			portrait.ID = i;
			portrait.hability = ['spear', 'bottle', 'prism', 'ice', 'fire', 'light'][portrait.ID];
			portraits.add(portrait);

			position.x += portrait.width + 8;

			if (i == 2)
				position.set(0, portrait.height * 1.25);
		}
		position.put();

		final boxWidth = 100 * Main.pixel_mult;
		portraits.x = bg.x + (bg.width - portraits.width) / 2;
		portraits.y = bg.y + bg.height - boxWidth + (boxWidth - portraits.height) / 2;

		var text = new FlxText(0, 0, 0, 'Primary attacks (up to 2)', 16);
		text.setPosition(portraits.x + (portraits.width - text.width) / 2, portraits.y - text.height - 4);
		text.active = false;
		add(text);

		var text = new FlxText(0, 0, 0, 'Super attacks (up to 2)', 16);
		text.setPosition(portraits.x + (portraits.width - text.width) / 2, portraits.y + portraits.height + 10);
		text.active = false;
		add(text);

		outlines = new FlxTypedGroup<BoxOutline>();
		add(outlines);

		selectOutline = new BoxOutline();
		add(selectOutline);

		play = new FlxButton(0, 0, 'Start', () ->
		{
			if (FlxG.sound.music != null && FlxG.sound.music.playing)
				FlxG.sound.music.stop();

			FlxG.switchState(new PlayState(build));
			FlxG.sound.play('assets/sounds/confirm.mp3', 0.85).persist = true;
		});
		play.setGraphicSize(play.width * 2);
		play.updateHitbox();
		play.label.setGraphicSize(play.label.width * 2);
		play.label.updateHitbox();
		play.setPosition(FlxG.width - 50 - play.width, FlxG.height - 30 - play.height);
		play.alpha = 0.5;
		play.active = false;
		add(play);

		var exit = new FlxButton(0, 0, 'Go back', () ->
		{
			FlxG.switchState(new MainMenu());
			FlxG.sound.play('assets/sounds/exit.mp3', 0.3).persist = true;
		});
		exit.setGraphicSize(exit.width * 2);
		exit.updateHitbox();
		exit.label.setGraphicSize(exit.label.width * 2);
		exit.label.updateHitbox();
		exit.setPosition(play.x - exit.width - 20, play.y);
		add(exit);

		descBox = new HabilityDescriptionBox();
		add(descBox);

		build = new CharacterBuild();
	}

	function increaseAIlevel(spr:FlxSprite):Void
	{
		curLevel++;

		if (curLevel > 10)
			curLevel = 1;

		levelText.text = 'AI level: $curLevel';
	}

	override function update(elapsed:Float):Void
	{
		descBox.visible = false;

		var found:BoxOutline = null;
		if (FlxG.mouse.overlaps(portraits))
		{
			descBox.visible = true;

			for (portrait in portraits.members)
			{
				if (FlxG.mouse.overlaps(portrait))
				{
					found = portrait;
					selectOutline.setPosition(portrait.x, portrait.y);
					descBox.text = habilityDescriptions.get(portrait.hability);
					break;
				}
			}
		}

		if (found == null)
			selectOutline.x = -1000;

		if (FlxG.mouse.justPressed && found != null)
		{
			addHability(found);
		}

		if (build.primary1 == null || build.primary2 == null || build.super1 == null || build.super2 == null)
		{
			play.alpha = 0.5;
			play.active = false;
		}
		else
		{
			play.alpha = 1;
			play.active = true;
		}

		super.update(elapsed);
	}

	function addHability(found:BoxOutline):Void
	{
		for (member in outlines.members)
		{
			if (member.alive)
			{
				if (member.x == found.x && member.y == found.y)
				{
					trace('found:', found, 'member:', member);

					if (member.ID <= 2)
					{
						if (build.primary1 == member.hability)
							build.primary1 = null;
						if (build.primary2 == member.hability)
							build.primary2 = null;
					}
					else
					{
						if (build.super1 == member.hability)
							build.super1 = null;
						if (build.super2 == member.hability)
							build.super2 = null;
					}

					member.kill();

					trace('Current build: $build.');

					FlxG.sound.play('assets/sounds/Coffee1.mp3', 0.3);

					return;
				}
			}
		}

		var outline = outlines.getFirstDead();
		if (outline == null)
		{
			outline = new BoxOutline();
			outline.animation.play('selected');
			outlines.add(outline);
		}
		else
			outline.revive();
		outline.setPosition(found.x, found.y);
		outline.ID = found.ID;

		var isSuper:Bool = found.ID > 2;

		if (!isSuper)
		{
			outline.hability = found.hability;

			build.setPrimary(outline.hability);
		}
		else
		{
			outline.hability = found.hability;

			build.setSuper(outline.hability);
		}

		trace('Current build: $build.');

		FlxG.sound.play('assets/sounds/Coffee2.mp3', 0.3);

		for (member in outlines.members)
		{
			if (member.alive && member.hability != build.primary1 && member.hability != build.primary2 && member.hability != build.super1
				&& member.hability != build.super2)
				member.kill();
		}
	}
}

private class BoxOutline extends FlxSprite
{
	public var hability:String;

	public function new()
	{
		super();

		loadGraphic('assets/images/attack_portraits.png', true, 32, 32);
		animation.add('idle', [6], 0, false);
		animation.add('selected', [7], 0, false);
		animation.play('idle');
		active = false;
		setGraphicSize(width * Main.pixel_mult);
		updateHitbox();
	}
}
