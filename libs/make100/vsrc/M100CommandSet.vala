using aroop;
using shotodol;

/** \addtogroup make100
 *  @{
 */
public class shotodol.M100CommandSet: Replicable {
	Set<M100Command> cmds;
	BrainEngine<M100Command> be;
	public M100CommandSet() {
		cmds = Set<M100Command>();
		be = new BrainEngine<M100Command>();
	}
	~M100CommandSet() {
		cmds.destroy();
	}
	public int list(OutputStream pad) {		
		cmds.visit_each((data) =>{
			unowned M100Command cmd = ((container<M100Command>)data).get();
			cmd.desc(M100Command.CommandDescType.COMMAND_DESC_TITLE, pad);
			//etxt*prefix = cmd.get_prefix();
			//if(prefix == null) return 0;
			//if(!prefix.equals(cmd_str)) return 0;
			//mycmd = cmd;
			return 0;
		}, Replica_flags.ALL, 0, Replica_flags.ALL, 0, 0, 0);
		return 0;
	}
	public int register(M100Command cmd) {
		print("Registering %s command\n", cmd.get_prefix().to_string());
		cmds.add(cmd);
		be.memorize_etxt(cmd.get_prefix(), cmd);
		return 0;
	}
	public int unregister(M100Command cmd) {
		// TODO fill me
		return 0;
	}
	public M100Command? percept(etxt*cmd_str) {
		return be.percept_prefix_match(cmd_str);//be.direction(cmd_str);
	}
}
/* @} */
