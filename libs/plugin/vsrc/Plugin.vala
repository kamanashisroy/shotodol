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
	HashTable<Extension>registry;
	public static Plugin?x;
	public Plugin() {
		name = etxt.from_static("Plugin");
		registry = HashTable<Extension>();
	}
	public static int register(txt target, Extension e) {
		Extension?root = x.registry.get(target);
		if(root == null) {
			x.registry.set(target, e);
			return 0;
		}
		while(root.next != null) {
			Extension next = root.next;
			root = next;
		}
		root.next = e;
		return 0;
	}
	public static Extension?get(txt target) {
		return x.registry.get(target);
	}
	public static int unregister(txt target, Extension e) {
		Extension?root = x.registry.get(target);
		if(root == null) return 0;
		if(root == e) {
			x.registry.set(target, root.next);
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
		// TODO fill me
		return 0;
	}
#if false
	public static void list(OutputStream pad) {
		registry.visit_each((data) =>{
			unowned Extension x = ((container<M100Command>)data).get();
			cmd.desc(M100Command.CommandDescType.COMMAND_DESC_TITLE, pad);
			return 0;
		}, Replica_flags.ALL, 0, Replica_flags.ALL, 0, 0, 0);
	}
#endif
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
