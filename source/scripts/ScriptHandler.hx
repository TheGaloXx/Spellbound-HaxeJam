package scripts;

import flixel.FlxG;
import haxe.Rest;
import haxe.ds.StringMap;
import hscript.Expr;
import hscript.Parser;
import openfl.Assets;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

// Thanks to my friend Sanco (again) for teaching me about hscript!!!
class ScriptHandler
{
	public static var exposure:StringMap<Dynamic> = ["FlxG" => FlxG];
	public static var modules:Map<String, Module> = [];

	private static final parser:Parser = new Parser();

	#if sys
	public static var customScripts:Map<String, String> = [];
	#end

	public static function init():Void
	{
		parser.allowTypes = true;
		parser.allowJSON = true;
		parser.allowMetadata = true;

		reloadCustomScripts();
	}

	public static function reloadCustomScripts():Void
	{
		#if sys
		customScripts.clear();

		final path:String = './assets/scripts/';
		if (!FileSystem.exists(path))
		{
			FileSystem.createDirectory(path);
		}
		else
		{
			for (file in FileSystem.readDirectory(path))
			{
				if (file.endsWith('.hx'))
				{
					final content:String = File.getContent(path + file);

					if (content.length > 0)
						customScripts.set(file.replace('.hx', ''), content);
				}
			}
		}
		#end
	}

	public static function load(name:String, ?extraParams:StringMap<Dynamic>):Void
	{
		final path = 'assets/scripts/$name.hx';

		var content:Null<String> = null;

		if (Assets.exists(path, TEXT))
			content = Assets.getText(path);
		#if sys
		else
			content = customScripts.get(name);
		#end

		if (content == null)
		{
			FlxG.log.error('Script in $path was not found...');
			return;
		}

		var expr:Expr = null;
		var module:Module = null;

		try
		{
			expr = parser.parseString(content);
			module = new Module(expr, extraParams);
			modules.set(name, module);
		}
		catch (ex:Error)
		{
			trace('HScript parsing exception ${ex}');
		}
	}

	public static function clean():Void
	{
		modules = [];
	}
}
