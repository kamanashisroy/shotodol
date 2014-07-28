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
	public void swarm(extring*target, extring*inmsg, extring*outmsg) {
		Extension?root = get(target);
		while(root != null) {
			root.act(inmsg, outmsg);
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
}
/** @}*/
