using aroop;
using shotodol;


public class shotodol.ProgrammingCommand : Command {
	etxt prfx;
	public override etxt*get_prefix() {
		prfx = etxt.from_static("avrprogram");
		return &prfx;
	}
	public virtual int act_on(etxt*cmdstr, StandardIO io) {
		// TODO add record
		// TODO say something
		io.say_static("Programming avr\n");
		return 0;
	}
}


public class shotodol.FlashProgramming : Module {
	public override int init() {
		// TODO register ProgrammingCommand
		return 0;
	}

	public override int deinit() {
		// TODO unregister ProgrammingCommand
		return 0;
	}
}
