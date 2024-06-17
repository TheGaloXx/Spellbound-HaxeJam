package objects.ui;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import objects.characters.BaseCharacter;
import states.PlayState;
import states.SelectionState;

class Bar extends FlxSpriteGroup
{
	private var magicFill:FlxSprite;
	private var magicRect:FlxRect = FlxRect.get();

	private var healthBar:FlxSprite;
	private var healthRect:FlxRect = FlxRect.get();

	public var habilities:Array<FlxSprite> = [];

	public function new(flip:Bool = false)
	{
		super();

		function makeFill():FlxSprite
		{
			var fill = new FlxSprite();
			fill.loadGraphic('assets/images/ui/magic_fill.png', true, 22, 22);
			fill.animation.add('idle', [0, 1], 0, false);
			fill.animation.play('idle');
			fill.setGraphicSize(fill.width * Main.pixel_mult);
			fill.updateHitbox();
			fill.flipX = flip;
			fill.active = false;
			add(fill);
			return fill;
		}

		var backFill = makeFill();
		backFill.animation.curAnim.curFrame = 1;
		magicFill = makeFill();

		var icon = new FlxSprite();
		icon.loadGraphic('assets/images/ui/magic_icon.png');
		icon.active = false;
		icon.setGraphicSize(icon.width * Main.pixel_mult);
		icon.updateHitbox();
		icon.flipX = flip;

		function makeBar():FlxSprite
		{
			var bar = new FlxSprite();
			bar.active = false;
			bar.loadGraphic('assets/images/ui/health_bar.png', true, 80, 16);
			bar.animation.add('idle', [0, 1], 0, false);
			bar.animation.play('idle');
			bar.flipX = flip;
			bar.setGraphicSize(bar.width * Main.pixel_mult);
			bar.updateHitbox();
			bar.y = (icon.height - bar.height) / 2;
			add(bar);

			final offset:Float = 3 * Main.pixel_mult;

			if (flip)
			{
				icon.x += (bar.width / 2) - Main.pixel_mult * 1.5;
			}
			else
				bar.x = icon.width - offset;

			return bar;
		}

		makeBar();

		healthBar = makeBar();
		healthBar.animation.curAnim.curFrame = 1;

		backFill.setPosition(icon.x + (icon.width - backFill.width) / 2, icon.y + (icon.height - backFill.height) / 2);
		magicFill.setPosition(backFill.x, backFill.y);
		add(icon);

		for (i in 0...2)
		{
			var hability = new FlxSprite();
			hability.loadGraphic('assets/images/ui/habilities.png', true, 6, 6);
			hability.animation.add('off', [0], 0, false);
			hability.animation.add('on', [1], 0, false);
			hability.animation.play('off');
			hability.setGraphicSize(hability.width * Main.pixel_mult);
			hability.updateHitbox();
			hability.flipX = flip;
			hability.active = false;
			hability.ID = i;
			add(hability);

			switch (i)
			{
				case 0:
					hability.offset.set(17, -27);
				case 1:
					hability.offset.set(-77, 22);
			}

			if (flip)
			{
				// make the 'x = 0' the top right corner of the icon and revert the offsets
				hability.x = icon.x + icon.width;
				hability.offset.x *= -1;
				hability.offset.x += Main.pixel_mult; // no clue why moving it a pixel fixes this but i'll take it
			}

			habilities.push(hability);
		}
	}

	public var oldHealth:Float;

	public function updateHealthBar(newHealth:Float):Void
	{
		if (!active)
			return;

		var rectWidth:Float = newHealth / 100 * healthBar.frameWidth;

		healthRect.set(0, 0, rectWidth, healthBar.height);
		healthBar.clipRect = healthRect;

		oldHealth = newHealth;
	}

	public var oldMagic:Float;

	public function updateMagicBar(newMagic:Float):Void
	{
		if (!active)
			return;

		var rectHeight:Float = (100 - newMagic) / 100 * magicFill.frameHeight;

		healthRect.set(0, 0, magicFill.width, rectHeight);
		magicFill.clipRect = healthRect;

		oldMagic = newMagic;

		if (newMagic >= 100)
		{
			angle = 5 * (habilities[0].flipX ? -1 : 1);
			FlxTween.tween(this, {angle: 0}, 0.1);
		}

		final state:PlayState = PlayState.current;
		final characterParent:BaseCharacter = (state.player.hudBar == this ? state.player : state.enemy);

		final rawCost:Dynamic = SelectionState.habilitiesJSON.get(characterParent.build.super1).cost;
		if (newMagic >= (Std.isOfType(rawCost, Float) ? cast rawCost : Std.parseFloat(rawCost)))
			habilities[0].animation.play('on');
		else
			habilities[0].animation.play('off');

		final rawCost:Dynamic = SelectionState.habilitiesJSON.get(characterParent.build.super2).cost;
		if (newMagic >= (Std.isOfType(rawCost, Float) ? cast rawCost : Std.parseFloat(rawCost)))
			habilities[1].animation.play('on');
		else
			habilities[1].animation.play('off');
	}

	override function destroy():Void
	{
		super.destroy();

		healthRect.put();
		magicRect.put();
	}
}
