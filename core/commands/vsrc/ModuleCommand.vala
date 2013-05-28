using aroop;
using shotodol;

internal class shotodol.ModuleCommand : Command {
	etxt prfx;
	public override etxt*get_prefix() {
		prfx = etxt.from_static("module");
		return &prfx;
	}
	public override int act_on(/*ArrayList<txt> tokens*/etxt*cmdstr, StandardIO io) {
		// TODO load module, show list of modules ..
		io.say_static("<Module command>");
		return 0;
	}
	
	public override int desc(StandardIO io, Command.CommandDescType tp) {
		etxt x = etxt.stack(32);
		switch(tp) {
			case Command.CommandDescType.COMMAND_DESC_TITLE:
			x.printf("%s\n", get_prefix().to_string());
			io.say_static(x.to_string());
			break;
			default:
			io.say_static("SYNOPSIS\nmodule [operation] [modulename]\nDESCRIPTION\nmodule command enables you to load and unload modules. The operation argument can be 'load' or 'unload'.\nEXAMPLE\nTo load console module, you can type\n\n\tmodule load console\n");
			break;
		}
		return 0;
	}
}
