package nodejs;

#if macro
import haxe.macro.Context;
import haxe.macro.TypeTools;
#end

class Extern
{
	macro public static function link(type : String, module : String, ?fun : String)
	{
		var packages = type.split('.').slice(0, -1),
			cls      = type.split('.').pop(),
			first    = packages.shift();

		var buf = [];
		if(null == first)
		{
			buf.push('$cls = require("$module")');
		} else {
			buf.push('var $first = "undefined" !== typeof $first ? $first : {}');
			var list = [first];
			packages.map(function(pack) {
				list.push(pack);
				var p = list.join('.');
				buf.push('$p = "undefined" !== typeof $p ? $p : {}');
			});
			list.push(cls);
			buf.push('${list.join(".")} = require("$module")${null != fun ? "." + fun : ""}');
		}

		var s = 'untyped __js__("'+StringTools.replace(buf.join(';\n'), '"', '\\"')+'")';

		return Context.parse(s, Context.currentPos());
	}
}