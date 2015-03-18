using aroop;
using shotodol;


/** \addtogroup shake
 *  @{
 */
public class shotodol.ShakeExtension : Extension {
	extring scriptName;
	extring targetFunction;
	unowned M100Script? script;
	public ShakeExtension(M100Script?givenScript, extring*givenScriptName, extring*givenTargetFunction, Module?mod) {
		script = givenScript;
		scriptName = extring.copy_deep(givenScriptName);
		targetFunction = extring();
		extring exten = extring.set_static_string("exten_");
		targetFunction.rebuild_in_heap(givenTargetFunction.length()+exten.length()+1);
		targetFunction.concat(&exten);
		int i = 0;
		for(i = 0; i < givenTargetFunction.length(); i++) {
			uchar c = givenTargetFunction.char_at(i);
			// replace '/' into '_' while coping ..
			targetFunction.concat_char(c == '/' ? '_' : c);
		}
		base(mod);
	}
	public override int desc(OutputStream pad) {
		base.desc(pad);
		extring dlg = extring.stack(128);
		dlg.concat_string("Shake source:");
		dlg.concat(&scriptName);
		dlg.concat_string("\nTarget function:");
		dlg.concat(&targetFunction);
		dlg.concat_char('\n');
		pad.write(&dlg);
		return 0;
	}
	public override int act(extring*msg, extring*scriptout) /*throws M100CommandError.ActionFailed*/ {
		//script.setOutputStream(new StandardOutputStream());
		extring dlg = extring.stack(128);
		dlg.printf("target:[%s]\n", targetFunction.to_string());
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&dlg);
#if false
		script.getField(script.GLOBAL_SPACE, targetFunction.to_string());
		script.pushEXtring(msg); // function argument is *msg*
		script.call(1,1,0);
		if(script.isString(-1)) {
			script.getXtringAs(scriptout, -1); // function return is scriptout
		}
		script.pop(1);
#else
		
		script.target(&targetFunction);
		while(true) {
			xtring? cmd = script.step();
			if(cmd == null) {
				break;
			}
			dlg.printf("command:%s\n", cmd.fly().to_string());
			Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&dlg);
			// execute command
			//cmds.act_on(cmd, pad, script);
		}
#endif
		return 0;
	}
}
/* @} */

