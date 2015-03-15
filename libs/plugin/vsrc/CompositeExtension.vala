using aroop;
using shotodol;

/** \addtogroup plugin
 *  @{
 */
public class shotodol.CompositeExtension : Extension {
	HashTable<xtring,Extension>registry;
#if USE_XTRING_BUFFER
	Factory<xtring> xtringBuffer;
#endif
	public CompositeExtension(Module mod) {
		base(mod);
		registry = HashTable<xtring,Extension>(xtring.hCb,xtring.eCb);
#if USE_XTRING_BUFFER
		xtringBuffer = Factory<xtring>.for_type_full(16,(uint)sizeof(extring)+16);
#endif
	}
	~CompositeExtension() {
		registry.destroy();
#if USE_XTRING_BUFFER
		xtringBuffer.destroy();
#endif
	}
	public int register(extring*target, Extension e, bool once = false) {
		core.assert(e.src != null);
		Extension?root = registry.getProperty(target);
		if(root == null) {
			//xtring tgt = new xtring.copy_on_demand(target, &xtringBuffer);
#if USE_XTRING_BUFFER
			xtring tgt = new xtring.copy_deep(target, &xtringBuffer);
#else
			xtring tgt = new xtring.copy_deep(target);
#endif
			core.assert(tgt != null);
			registry.set(tgt, e);
			return 0;
		}
		if(once)
			return -1;
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
			core.assert(tgt != null);
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
	public int unregisterModule(Module mod, OutputStream?pad) {
		int pruneFlag = 1<<1;
		//aroop.Iterator<AroopPointer<Extension>>it = aroop.Iterator<AroopPointer<Extension>>.EMPTY();
		aroop.Iterator<AroopHashTablePointer<xtring,Extension>>it = aroop.Iterator<AroopHashTablePointer<xtring,Extension>>();
		buildIterator(&it);
		while(it.next()) {
			unowned AroopHashTablePointer<xtring,Extension> map = (AroopHashTablePointer<xtring,Extension>)it.get_unowned();
			unowned Extension root = map.getUnowned();
			// fix the root node
			if(root.src == mod) {
//#if AROOP_OPP_DEBUG
				print("Deleting root extension .. for %s\n", map.key().fly().to_string());
				if(pad != null)root.desc(pad);
//#endif
				if(root.next == null) {
					map.mark(pruneFlag);
					continue;
				}
				Extension e = root.next;
				while(e != null) {
					if(e.src != mod) {
						break;
					}
//#if AROOP_OPP_DEBUG
					print("Deleting extension node .. for %s\n", map.key().fly().to_string());
					if(pad != null)e.desc(pad);
//#endif
					Extension next = e.next;
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
//#if AROOP_OPP_DEBUG
					print("Deleting extension node .. for %s\n", map.key().fly().to_string());
					if(pad != null)next.desc(pad);
//#endif
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
	public int swarm(extring*target, extring*inmsg, extring*outmsg) {
		int retVal = 0;
		Extension?root = get(target);
		while(root != null) {
			retVal = root.act(inmsg, outmsg);
			Extension?next = root.getNext();
			root = next;
		}
		return retVal;
	}
	public void acceptVisitor(extring*target, ExtensionVisitor visitor) {
		Extension?root = get(target);
		while(root != null) {
			visitor(root);
			Extension?next = root.getNext();
			root = next;
		}
	}
	public void buildIterator(aroop.Iterator<AroopHashTablePointer<xtring,Extension>>*it) {
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
		aroop.Iterator<AroopHashTablePointer<xtring,Extension>>it = aroop.Iterator<AroopHashTablePointer<xtring,Extension>>();
		buildIterator(&it);
		while(it.next()) {
			unowned AroopHashTablePointer<xtring,Extension> map = (AroopHashTablePointer<xtring,Extension>)it.get_unowned();
			unowned Extension e = map.getUnowned();
			do {
				dlg.truncate();
				dlg.concat(map.key());
				dlg.concat_string("\t\t\t\t\t");
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
