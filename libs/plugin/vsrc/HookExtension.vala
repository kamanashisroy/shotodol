using aroop;
using shotodol;

/** \addtogroup Plugin
 *  @{
 */
public delegate int shotodol.PluginHook(estr*msg, estr*output);
public class shotodol.HookExtension : Extension {
	PluginHook hook;
	public HookExtension(PluginHook?gHook, Module mod) {
		base(mod);
		hook = gHook;
	}
	public override int act(estr*msg, estr*output) {
		return hook(msg, output);
	}
}
/** @}*/
