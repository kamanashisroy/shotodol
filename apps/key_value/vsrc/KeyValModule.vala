using aroop;
using shotodol;


public class shotodol.KeyValAddCmd : M100Command {
	etxt prfx;
	public override etxt*get_prefix() {
		prfx = etxt.from_static("Idono");
		return &prfx;
	}
	public virtual int act_on(/*ArrayList<txt> tokens*/etxt*cmdstr, StandardIO io) {
		// TODO add record
		// TODO say something
		io.say_static("Adding new entry\n");
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
