using aroop;
using shotodol;

/** \addtogroup Plugin
 *  @{
 */
public delegate int shotodol.PluginHook(etxt*msg, etxt*output);
public class shotodol.HookExtension : Extension {
	PluginHook hook;
	public HookExtension(PluginHook?gHook, Module mod) {
		base(mod);
		hook = gHook;
	}
	public override int act(etxt*msg, etxt*output) {
		return hook(msg, output);
	}
}
/** @}*/
