using aroop;
using shotodol;
using shotodol_lua;


/** \addtogroup script
 *  @{
 */
#if LUA_LIB
public class shotodol.LuaExtension : Extension {
	extring scriptName;
	extring targetFunction;
	unowned LuaStack? script;
	public LuaExtension(LuaStack givenScript, extring*givenScriptName, extring*givenTargetFunction, Module?mod) {
		script = givenScript;
		scriptName = extring.copy_deep(givenScriptName);
		targetFunction = extring();
		extring exten = extring.set_static_string("exten_");
		targetFunction.buffer(givenTargetFunction.length()+exten.length()+1);
		targetFunction.concat(&exten);
		targetFunction.concat(givenTargetFunction);
		base(mod);
	}
	public override int desc(OutputStream pad) {
		base.desc(pad);
		extring dlg = extring.stack(128);
 		dlg.printf("Lua source:%s\nTarget function:%s\n", scriptName.to_string(), targetFunction.to_string());
		pad.write(&dlg);
		return 0;
	}
	public override int act(extring*msg, extring*scriptout) /*throws M100CommandError.ActionFailed*/ {
		//script.setOutputStream(new StandardOutputStream());
		extring dlg = extring.stack(128);
		dlg.printf("target:[%s]\n", targetFunction.to_string());
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&dlg);
		script.getField(script.GLOBAL_SPACE, targetFunction.to_string());
		script.pushEXtring(msg); // function argument is *msg*
		script.call(1,1,0);
		if(script.isString(-1)) {
			script.getXtringAs(scriptout, -1); // function return is scriptout
		}
		script.pop(1);
		return 0;
	}
}
#endif
/* @} */

