using aroop;
using shotodol;

/**
 * \ingroup library
 * \defgroup plugin Plugin
 * refer to external coupling
 */

/** \addtogroup Plugin
 *  @{
 */
public delegate void shotodol.ExtensionVisitor(Extension e);
public class shotodol.Plugin : Module {
	static CompositeExtension x;
	public Plugin() {
		extring nm = extring.set_static_string("Plugin");
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
	}
	public static int register(extring*target, Extension e) {
		return x.register(target, e);
	}
	public static int unregister(extring*target, Extension e) {
		return x.unregister(target, e);
	}
	public static int unregisterModule(Module mod) {
		return x.unregisterModule(mod);
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
