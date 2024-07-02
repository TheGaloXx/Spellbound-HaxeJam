package scripts;

import haxe.Rest;
import haxe.ds.StringMap;
import hscript.Expr;
import hscript.Interp;

class Module
{
	public var interp:Interp;

	public function new(contents:Expr, ?extraParams:StringMap<Dynamic>)
	{
		interp = new Interp();

		for (k => v in ScriptHandler.exposure)
			set(k, v);

		if (extraParams != null)
		{
			for (k => v in extraParams)
				set(k, v);
		}

		interp.execute(contents);
	}

	public function run(func:String, args:Rest<Dynamic>)
	{
		try
		{
			if (this.exists(func))
				Reflect.callMethod(this.interp.variables, this.get(func), args.toArray());
		}
		catch (ex)
		{
			trace('Failed to execute $func on modules ($ex)');
		}
	}

	public function get(field:String):Dynamic
		return interp.variables.get(field);

	public function set(field:String, value:Dynamic):Void
		interp.variables.set(field, value);

	public function exists(field:String):Bool
		return interp.variables.exists(field);
}
