package starling.utils;
import haxe.macro.Context;
import haxe.macro.Expr;

class SafeCast
{

	macro public static function safe_cast(value:Expr, type:Expr)
	{
		if (Context.defined ("cs"))
			return macro cs.Lib.as($value, $type);
		
		switch(value.expr)
		{
		case EConst(c):
			//trace('$value is a constant');
			return macro Std.is($value, $type) ? cast $value : null;
		default:
			//trace('!$value');
			return macro $b { [(macro var e = $value), (macro Std.is(e, $type) ? cast e : null)] };
		}
	}
	
}