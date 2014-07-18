using aroop;
using shotodol;

/** \addtogroup Plugin
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
}
/** @}*/
