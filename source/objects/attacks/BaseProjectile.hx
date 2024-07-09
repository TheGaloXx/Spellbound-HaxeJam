package objects.attacks;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import lime.utils.Assets;
import objects.characters.BaseCharacter;
import scripts.Module;
import scripts.ScriptHandler;
import states.PlayState;
import states.SelectionState;
#if sys
import openfl.display.BitmapData;
import sys.FileSystem;
#end

class BaseProjectile extends FlxSprite
{
	private var frameSize:Null<Int>;
	private var size:Null<Float>;
	private var hitboxSize:Null<Float>;

	public var type:String;
	public var parent:BaseCharacter;
	public var enemy:BaseCharacter;
	public var damage:Null<Float>;
	public var magicGain:Null<Float> = 10;
	public var speed:Null<Float>;
	public var cooldown:Null<Float>;

	public var script:Module;

	public function new(type:String, speed:Float, size:Float = 1, hitboxSize:Float = 1)
	{
		super();

		this.script = ScriptHandler.modules.get(type);
		this.type = type;
		this.speed = script?.getVar('speed');
		this.size = script?.getVar('size');
		this.hitboxSize = script?.getVar('hitboxSize');
		this.damage = script?.getVar('damage');
		this.frameSize = script?.getVar('frameSize');
		this.cooldown = script?.getVar('cooldown');

		loadImage();

		setGraphicSize(frameSize * Main.pixel_mult);
		updateHitbox();

		script?.run('onInit');
	}

	private function loadImage():Void
	{
		var path:Null<String> = null;
		var bitmap:FlxGraphicAsset = null;

		path = 'assets/images/gameplay/attacks/$type.png';
		if (Assets.exists(path, IMAGE))
			bitmap = FlxG.bitmap.add(path, false, 'ATTACK_$type');
		#if sys
		else
		{
			path = './assets/images/custom_attacks/$type';
			if (FileSystem.exists(path))
			{
				bitmap = BitmapData.fromFile(path);
			}
		}
		#end
		loadGraphic(bitmap, script?.getVar('animated'), frameSize, frameSize);
	}

	public function init(parent:BaseCharacter, runScript:Bool = true):Void
	{
		this.parent = parent;
		this.enemy = (PlayState.current.player == parent ? PlayState.current.enemy : PlayState.current.player);

		velocity.set();
		acceleration.set();

		setGraphicSize(frameSize * Main.pixel_mult);
		updateHitbox();
		setAttackHitbox();

		angle = 0;
		alpha = 1;

		visible = true;
		active = true;

		checkTime = 0;
		timeAlive = 0;

		if (runScript)
			script?.run('onRun', this, PlayState.current);
	}

	public inline function setAttackHitbox():Void
	{
		// update the hitbox "technically"
		final scaleX = scale.x * size;
		final scaleY = scale.y * size;
		scale.set(scaleX * hitboxSize, scaleY * hitboxSize);
		updateHitbox();

		// go back to the original size visually
		scale.set(scaleX, scaleY);
	}

	public function getAimPoint():FlxPoint
	{
		if (this.parent == PlayState.current.enemy)
			return FlxPoint.get(this.enemy.x + this.enemy.width / 2, this.enemy.y + this.enemy.height / 2);

		return FlxPoint.get(FlxG.mouse.screenX, FlxG.mouse.screenY);
	}

	override function kill():Void
	{
		script?.run("onKill");

		active = false;
		parent = null;
		enemy = null;

		super.kill();
	}

	@:noCompletion var timeAlive:Float = 0;
	@:noCompletion var checkDelay:Float = 3;
	@:noCompletion var checkTime:Float = 0;

	override function update(elapsed:Float):Void
	{
		// check every 3 seconds (after 3 seconds of spawning) if this projectile is offcamera, kill it if it is
		if (timeAlive < 3)
			timeAlive += elapsed;
		else
		{
			checkTime += elapsed;
			if (checkTime >= checkDelay)
			{
				checkTime = 0;

				if (!isOnScreen())
				{
					kill();
					return;
				}
			}
		}

		script?.run("onUpdate");

		super.update(elapsed);
	}

	override function destroy():Void
	{
		super.destroy();

		script = null;
		size = null;
		hitboxSize = null;
		type = null;
		parent = null;
		enemy = null;
		damage = null;
		magicGain = null;
		speed = null;
		cooldown = null;
		frameSize = null;
	}
}
