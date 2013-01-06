using aroop;
using shotodol;


public class shotodol.KeyValAddCmd : Command {
	public override int act_on(ArrayList<txt> tokens, StandardIO io) {
		// TODO add record
		// TODO say something
		io.say("Adding new entry\n");
		return 0;
	}
}


public class shotodol.KeyValModule : Module {
	public override int init() {
		// TODO allocate in-memory key-value database ..
		// TODO add commands to access the database ..
		return 0;
	}

	public override int deinit() {
		// TODO deinit
		return 0;
	}
}
