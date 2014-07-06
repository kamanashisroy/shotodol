using aroop;
using shotodol;

/**
 * \ingroup library
 * \defgroup plugin Plugin
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
		x.registry.set(target, e);
		return 0;
	}
	public static Extension?get(txt target) {
		return x.registry.get(target);
	}
	public static int unregister(txt target, Extension e) {
		Extension ex = x.registry.get(target);
		if(ex == e) {
			x.registry.set(target, null);
		}
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
