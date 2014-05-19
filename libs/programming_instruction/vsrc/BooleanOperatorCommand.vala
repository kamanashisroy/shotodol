using aroop;
using shotodol;

/** \addtogroup control_command
 *  @{
 */
public class shotodol.BooleanOperatorCommand : shotodol.M100Command {
	etxt prfx;
	unowned M100CommandSet cmds;
	enum Options {
		X = 1,
		Y,
		Z,
	}
	public BooleanOperatorCommand(M100CommandSet gCmds) {
		base();
		cmds = gCmds;
		etxt x = etxt.from_static("-x");
		etxt x_help = etxt.from_static("First variable or value");
		etxt y = etxt.from_static("-y");
		etxt y_help = etxt.from_static("Second variable or value");
		etxt z = etxt.from_static("-z");
		etxt z_help = etxt.from_static("Output variable");
		addOption(&x, M100Command.OptionType.TXT, Options.X, &x_help);
		addOption(&y, M100Command.OptionType.TXT, Options.Y, &y_help);
		addOption(&z, M100Command.OptionType.TXT, Options.Z, &z_help);
	}
	public override int act_on(etxt*cmdstr, OutputStream pad) {
		greet(pad);
		SearchableSet<txt> vals = SearchableSet<txt>();
		if(parseOptions(cmdstr, &vals) != 0) {
			desc(CommandDescType.COMMAND_DESC_FULL, pad);
			bye(pad, false);
			return 0;
		}
		container<txt>? mod;
		mod = vals.search(Options.X, match_all);
		if(mod == null) {
			bye(pad, false);
			return 0;
		}
		txt x = mod.get();
		mod = vals.search(Options.Y, match_all);
		if(mod == null) {
			bye(pad, false);
			return 0;
		}
		txt y = mod.get();
		if(x.is_empty_magical() || y.is_empty_magical()) {
			bye(pad, false);
			return 0;
		}
		mod = vals.search(Options.Z, match_all);
		if(mod == null) {
			bye(pad, false);
			return 0;
		}
		txt z = mod.get();
		if(z.is_empty_magical() || (z.char_at(0) - '0') <= 9) {
			bye(pad, false);
			return 0;
		}
#if false
		int outlen = x.length() + y.length() + 128;
		etxt out = etxt.stack(outlen);
#endif
		uchar xdigit = x.char_at(0) - '0';
		etxt dlg = etxt.stack(128);
		dlg.printf("%s comparison\n", ((xdigit <= 9) && (xdigit >= 0)) ? "Integer" : "String" );
		pad.write(&dlg);
#if false
		int val = execOperation(&out,x,y,(xdigit <= 9) && (xdigit >= 0));
#else
		int val = execOperation(x,y,(xdigit <= 9) && (xdigit >= 0));
#endif
		M100Variable mval = new M100Variable();
		mval.setBool(val == 1?true:false);
		cmds.vars.set(z, mval);
		bye(pad, true);
		return 0;
	}
	protected virtual int execOperation(txt x, txt y, bool isInt) {
		return 0;
	}
}
internal class shotodol.LessThanCommand : shotodol.BooleanOperatorCommand {
	etxt prfx;
	public LessThanCommand(M100CommandSet cmds) {
		base(cmds);
	}
	public override etxt*get_prefix() {
		prfx = etxt.from_static("lt");
		return &prfx;
	}
	protected override int execOperation(txt x, txt y, bool isInt) {
		if(isInt) {
			int xval = ((etxt*)x).to_int();
			int yval = ((etxt*)y).to_int();
			if(xval < yval) {
				return 1;
			}
		}
		return 0;
	}
}
internal class shotodol.GreaterThanCommand : shotodol.BooleanOperatorCommand {
	etxt prfx;
	public GreaterThanCommand(M100CommandSet cmds) {
		base(cmds);
	}
	public override etxt*get_prefix() {
		prfx = etxt.from_static("gt");
		return &prfx;
	}
	protected override int execOperation(txt x, txt y, bool isInt) {
		if(isInt) {
			int xval = ((etxt*)x).to_int();
			int yval = ((etxt*)y).to_int();
			if(xval > yval) {
				return 1;
			}
		}
		return 0;
	}
}
internal class shotodol.EqualsCommand : shotodol.BooleanOperatorCommand {
	etxt prfx;
	public EqualsCommand(M100CommandSet cmds) {
		base(cmds);
	}
	public override etxt*get_prefix() {
		prfx = etxt.from_static("eq");
		return &prfx;
	}
	protected override int execOperation(txt x, txt y, bool isInt) {
		if(isInt) {
			int xval = ((etxt*)x).to_int();
			int yval = ((etxt*)y).to_int();
			if(xval == yval) {
				return 1;
			}
		} else if(x.equals(y)) {
			return 1;
		}
		return 0;
	}
}
/* @} */
