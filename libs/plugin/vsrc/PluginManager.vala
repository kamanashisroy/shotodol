using aroop;
using shotodol;

/**
 * \ingroup library
 * \defgroup shotodol_library Shotodol Static Libraries
 */

/**
 * \ingroup shotodol_library
 * \defgroup plugin Plugin
 * refer to external coupling
 */

/** \addtogroup plugin
 *  @{
 */
public delegate void shotodol.ExtensionVisitor(Extension e);
public class shotodol.PluginManager : Module {
	static CompositeExtension?x;
	public PluginManager() {
		extring nm = extring.set_string(core.sourceModuleName());
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
		x = null;
	}
	public static int register(extring*target, Extension e) {
		return x.register(target, e);
	}
	public static int unregister(extring*target, Extension e) {
		return x.unregister(target, e);
	}
	public static int unregisterModule(Module mod, OutputStream?pad = null) {
		if(x != null)
			return x.unregisterModule(mod, pad);
		return 0;
	}
	public static void swarm(extring*target, extring*inmsg, extring*outmsg) {
		x.swarm(target, inmsg, outmsg);
		extring composite = extring.set_static_string("extension/composite");
		Extension?root = x.get(&composite);
		while(root != null) {
			CompositeExtension cx = (CompositeExtension)root;
			cx.swarm(target, inmsg, outmsg);
			Extension?next = root.getNext();
			root = next;
		}
	}
	public static void acceptVisitor(extring*target, ExtensionVisitor visitor) {
		x.acceptVisitor(target, visitor);
		extring composite = extring.set_static_string("extension/composite");
		Extension?root = x.get(&composite);
		while(root != null) {
			CompositeExtension cx = (CompositeExtension)root;
			cx.acceptVisitor(target, visitor);
			Extension?next = root.getNext();
			root = next;
		}
	}
	public static void list(OutputStream pad) {
		x.list(pad);
	}
	
	public override int init() {
		x = new CompositeExtension(this);
		return 0;
	}
	public override int deinit() {
		x = null;
		return 0;
	}
}
/** @}*/
