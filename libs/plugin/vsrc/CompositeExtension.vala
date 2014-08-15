using aroop;
using shotodol;

/** \addtogroup Plugin
 *  @{
 */
public class shotodol.CompositeExtension : Extension {
	HashTable<xtring,Extension>registry;
	public CompositeExtension(Module mod) {
		base(mod);
		registry = HashTable<xtring,Extension>(xtring.hCb,xtring.eCb);
	}
	~CompositeExtension() {
		registry.destroy();
	}
	public int register(extring*target, Extension e) {
		Extension?root = registry.getProperty(target);
		if(root == null) {
			xtring tgt = new xtring.copy_on_demand(target);
			registry.set(tgt, e);
			return 0;
		}
		while(root.next != null) {
			Extension next = root.next;
			root = next;
		}
		root.next = e;
		return 0;
	}
	public Extension?get(extring*target) {
		return registry.getProperty(target);
	}
	public int unregister(extring*target, Extension e) {
		Extension?root = registry.getProperty(target);
		if(root == null) return 0;
		if(root == e) {
			xtring tgt = new xtring.copy_on_demand(target);
			registry.set(tgt, root.next);
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
	public int unregisterModule(Module mod) {
		int pruneFlag = 1<<1;
		aroop.Iterator<AroopPointer<Extension>>it = aroop.Iterator<AroopPointer<Extension>>.EMPTY();
		buildIterator(&it);
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
					e.next = null;
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
					next.next = null;
				} else {
					root = next;
				}
			}
		}
		it.destroy();
		registry.pruneMarked(pruneFlag);
		//registry.gc_unsafe();
		extring str = extring.set_static_string("rehash");
		swarm(&str, null, null);
		return 0;

	}
	public void swarm(extring*target, extring*inmsg, extring*outmsg) {
		Extension?root = get(target);
		while(root != null) {
			root.act(inmsg, outmsg);
			Extension?next = root.getNext();
			root = next;
		}
	}
	public void acceptVisitor(extring*target, ExtensionVisitor visitor) {
		Extension?root = get(target);
		while(root != null) {
			visitor(root);
			Extension?next = root.getNext();
			root = next;
		}
	}
	public void buildIterator(aroop.Iterator<AroopPointer<Extension>>*it) {
		registry.iterator_hacked(it);
	}
	public int count() {
		return registry.count_unsafe();
	}
	public override int desc(OutputStream pad) {
		base.desc(pad);
		extring dlg = extring.stack(128);
		dlg.concat_string("\tComposite,\n");
		pad.write(&dlg);
		return 0;
	}
	public void list(OutputStream pad) {
		extring dlg = extring.stack(128);
		dlg.printf("There are %d extensions registered\n", count());
		pad.write(&dlg);
		aroop.Iterator<AroopPointer<Extension>>it = aroop.Iterator<AroopPointer<Extension>>.EMPTY();
		buildIterator(&it);
		while(it.next()) {
			AroopHashTablePointer<xtring,Extension> map = (AroopHashTablePointer<xtring,Extension>)it.get_unowned();
			Extension e = map.get();
			do {
				dlg.printf("%s\t\t\t\t\t", map.key().fly().to_string());
				pad.write(&dlg);
				e.desc(pad);
				Extension next = e.next;
				e = next;
			} while(e != null);
		}
		it.destroy();
		extring composite = extring.set_static_string("extension/composite");
		Extension?root = get(&composite);
		while(root != null) {
			CompositeExtension cx = (CompositeExtension)root;
			cx.list(pad);
			Extension?next = root.getNext();
			root = next;
		}
	}
}
/** @}*/
