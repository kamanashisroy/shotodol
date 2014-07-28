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
	public static Extension?get(extring*target) {
		return x.get(target);
	}
	public static int unregister(extring*target, Extension e) {
		return x.unregister(target, e);
	}
	public static int unregisterModule(Module mod) {
		int pruneFlag = 1<<1;
		aroop.Iterator<AroopPointer<Extension>>it = aroop.Iterator<AroopPointer<Extension>>.EMPTY();
		x.buildIterator(&it);
		while(it.next()) {
			AroopPointer<Extension> map = it.get_unowned();
			Extension root = map.get();
			// fix the root node
			if(root.src == mod) {
				if(root.next == null) {
					map.mark(pruneFlag);
					continue;
				}
				Extension e = root.next;
				while(e != null) {
					if(e.src != mod) {
						break;
					}
					unowned Extension next = e.next;
					e = next;
				}
				if(e == null) {
					map.mark(pruneFlag);
					continue;
				}
				map.set(e);
				root = e;
			}
			// fix the others
			while(root.next != null) {
				Extension next = root.next;
				if(next.src == mod) {
					root.next = next.next;
				} else {
					root = next;
				}
			}
		}
		it.destroy();
		//x.registry.pruneMarked(pruneFlag);
		//x.registry.gc_unsafe();
		extring str = extring.set_static_string("rehash");
		swarm(&str, null, null);
		return 0;
	}
	public static void swarm(extring*target, extring*inmsg, extring*outmsg) {
		x.swarm(target, inmsg, outmsg);
		extring composite = extring.set_static_string("extension/composite");
		Extension?root = get(&composite);
		while(root != null) {
			CompositeExtension cx = (CompositeExtension)root;
			cx.swarm(target, inmsg, outmsg);
			Extension?next = root.getNext();
			root = next;
		}
	}
	public static void list(OutputStream pad) {
		extring dlg = extring.stack(128);
		dlg.printf("There are %d extensions registered\n", x.count());
		pad.write(&dlg);
		aroop.Iterator<AroopPointer<Extension>>it = aroop.Iterator<AroopPointer<Extension>>.EMPTY();
		x.buildIterator(&it);
		while(it.next()) {
			AroopPointer<Extension> map = it.get_unowned();
			Extension e = map.get();
			do {
				e.desc(pad);
				Extension next = e.next;
				e = next;
			} while(e != null);
		}
		it.destroy();
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
