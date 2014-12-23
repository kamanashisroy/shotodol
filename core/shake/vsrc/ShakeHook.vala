using aroop;
using shotodol;

/** \addtogroup shake
 *  @{
 */
public class shotodol.ShakeHook : HookExtension {
	extring extensionPoint;
	extring rule;
	public ShakeHook(extring*hook, Module mod) {
		extensionPoint = extring.copy_on_demand(hook);
		rule = extring();
		base(onEvent,mod);
		int i = 0;
		rule.rebuild_in_heap(extensionPoint.length()+1);
		for(i = 0; i < extensionPoint.length(); i++) {
			uchar c = extensionPoint.char_at(i);
			// replace '/' into '_' while coping ..
			rule.concat_char(c == '/' ? '_' : c);
		}
	}
	public int plug() {
		Plugin.register(&extensionPoint, this);
		return 0;
	}
	int onEvent(extring*msg, extring*output) {
		extring cmd = extring.stack(128);
		cmd.concat_string("shake -t ");
		cmd.concat(&rule);
		CommandModule.server.cmds.act_on(&cmd, new StandardOutputStream(), null);
		return 0;
	}
}
/* @} */

