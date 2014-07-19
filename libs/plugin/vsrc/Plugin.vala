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
	HashTable<xtring,Extension>registry;
	public static Plugin?x;
	public Plugin() {
		extring nm = extring.set_static_string("Plugin");
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
		registry = HashTable<xtring,Extension>(xtring.hCb,xtring.eCb);
	}
	public static int register(extring*target, Extension e) {
		Extension?root = x.registry.getProperty(target);
		if(root == null) {
			xtring tgt = new xtring.copy_on_demand(target);
			x.registry.set(tgt, e);
			return 0;
		}
		while(root.next != null) {
			Extension next = root.next;
			root = next;
		}
		root.next = e;
		return 0;
	}
	public static Extension?get(extring*target) {
		return x.registry.getProperty(target);
	}
	public static int unregister(extring*target, Extension e) {
		Extension?root = x.registry.getProperty(target);
		if(root == null) return 0;
		if(root == e) {
			xtring tgt = new xtring.copy_on_demand(target);
			x.registry.set(tgt, root.next);
			return 0;
		}
		while(root.next != null) {
			Extension next = root.next;
			root = next;
			if(root.next == e) {
				root.next = e.next;
				return 0;
			}
		}
		return 0;
	}
	public static int unregisterModule(Module mod) {
		int pruneFlag = 1<<1;
		aroop.Iterator<AroopPointer<Extension>>it = aroop.Iterator<AroopPointer<Extension>>.EMPTY();
		x.registry.iterator_hacked(&it);
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
		x.registry.pruneMarkedPointer(pruneFlag);
		extring str = extring.set_static_string("rehash");
		swarm(&str, null, null);
		return 0;
	}
	public static void swarm(extring*target, extring*inmsg, extring*outmsg) {
		Extension?root = Plugin.get(target);
		while(root != null) {
			root.act(inmsg, outmsg);
			Extension?next = root.getNext();
			root = next;
		}
	}
	public static void list(OutputStream pad) {
		extring dlg = extring.stack(128);
		dlg.printf("There are %d extensions registered\n", x.registry.count_unsafe());
		pad.write(&dlg);
		aroop.Iterator<AroopPointer<Extension>>it = aroop.Iterator<AroopPointer<Extension>>.EMPTY();
		x.registry.iterator_hacked(&it);
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
	~Plugin() {
		registry.destroy();
	}
	
	public override int init() {
		x = this;
		return 0;
	}
	public override int deinit() {
		x = null;
		return 0;
	}
}
/** @}*/
