using aroop;
using shotodol;


/** \addtogroup shake
 *  @{
 */
public class shotodol.ShakeExtension : Extension {
	extring scriptName;
	extring targetFunction;
	public ShakeExtension(extring*givenScriptName, extring*givenTargetFunction, Module?mod) {
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
	public override int act(extring*msg, extring*scriptOut) /*throws M100CommandError.ActionFailed*/ {
		extring dlg = extring.stack(128);
		dlg.printf("target:[%s]\n", targetFunction.to_string());
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&dlg);

		extring cmd = extring.stack(128);
		cmd.concat_string("shake -t ");
		cmd.concat(&targetFunction);
		cmd.concat_char('\r');
		cmd.concat_char('\n');
		
		extring serv = extring.set_static_string("command/server");
		return PluginManager.swarm(&serv, &cmd, scriptOut);
	}
}
/* @} */

