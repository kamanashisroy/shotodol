using aroop;
using shotodol;

/** \addtogroup plugin
 *  @{
 */
public delegate int shotodol.PluginHook(extring*msg, extring*output);
public class shotodol.HookExtension : Extension {
	PluginHook hook;
	public HookExtension(PluginHook?gHook, Module mod) {
		base(mod);
		hook = gHook;
	}
	public override int act(extring*msg, extring*output) {
		return hook(msg, output);
	}
	public override int desc(OutputStream pad) {
		base.desc(pad);
		extring dlg = extring.set_static_string("\tHook,\n");
		pad.write(&dlg);
		return 0;
	}
}
/** @}*/
