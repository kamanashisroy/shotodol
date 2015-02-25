using aroop;
using shotodol;

/** \addtogroup make100
 *  @{
 */

public errordomain M100CommandError.ActionFailed {
	INSUFFICIENT_ARGUMENT,
	INVALID_ARGUMENT,
	OTHER,
}

//public delegate void shotodol.M100CommandOptionVisitor(M100CommandOption opt);
public abstract class shotodol.M100Command : Replicable {
	public enum CommandDescType {
		COMMAND_DESC_TITLE,
		COMMAND_DESC_FULL,
	}
	public enum FlowControl {
		KEEP_GOING = 0,
		SKIP_BLOCK,
		GOTO_LINENO = 500,
	}
	public enum OptionType {
		TXT,
		INT,
		NONE;
		public void asText(extring*buf) {
			switch(this) {
				case TXT:
					buf.concat_string("<text>");
					return;
				case INT:
					buf.concat_string("<integer>");
					return;
				case NONE:
					buf.concat_string("<none>");
					return;
				default:
					break;
			}
		}
	}
	extring prfx;
	SearchableFactory<M100CommandOption> options;
	public M100Command(extring*prefix) {
		options = SearchableFactory<M100CommandOption>.for_type(4, 1, factory_flags.SWEEP_ON_UNREF | factory_flags.EXTENDED | factory_flags.SEARCHABLE | factory_flags.MEMORY_CLEAN);
		prfx = extring.copy_on_demand(prefix);
	}
	
	~M100Command() {
		prfx.destroy();
		options.destroy();
	}

#if false
	public int match_all(container<xtring> can) {
		return 0;
	}
#endif
	public void addOption(extring*prefix, OptionType tp, aroop_hash id, extring*help) {
		M100CommandOption opt = options.alloc_full();
		opt.pin();
		opt.build(prefix, tp, id, help);
	}

	public void addOptionString(string pre, OptionType tp, aroop_hash id, string he) {
		xtring prefix = new xtring.copy_string(pre);
		xtring help = new xtring.copy_string(he);
		M100CommandOption opt = options.alloc_full();
		opt.pin();
		opt.build2(prefix, tp, id, help);
	}
	
	public int parseOptions(extring*cmdstr, ArrayList<xtring>*val) {
		try {
			M100CommandOption.parseOptions(cmdstr, val, &options);
		} catch(M100CommandOptionError.ParseError e) {
			// TODO say error while parsing ..
			return -1;
		}
		return 0;
	}

	public virtual void greet(OutputStream pad) {
		extring greetings = extring.stack(128);
		greetings.printf("<%16s> -----------------------------------------------------------------\n" , prfx.to_string());
		pad.write(&greetings);
	} 
	public virtual void bye(OutputStream pad, bool success) {
		extring byebye = extring.stack(128);
		byebye.printf("<%16s> -----------------------------------------------------------------\n" , success?"Successful":"Failed");
		pad.write(&byebye);
		if(!success)
		desc(CommandDescType.COMMAND_DESC_FULL, pad);
	} 
	
	public void getPrefixAs(extring*outvar) {
		outvar.rebuild_and_copy_shallow(&prfx);
	}
	public virtual int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		return 0;
	}
	public void getOptionsIterator(Iterator<M100CommandOption>*it) {
		//Iterator<M100CommandOption> it = Iterator<M100CommandOption>(&options, Replica_flags.ALL, 0, 0);
		options.iterator(it, Replica_flags.ALL, 0, 0);
		return;
/*
		while(it.next()) {
			M100CommandOption? opt = it.get();
			visitor(opt);
		}
*/
	}
	public virtual int desc(CommandDescType tp, OutputStream pad) {
		extring x = extring.stack(32);
		x.printf("%s\n", prfx.to_string());
		switch(tp) {
			case CommandDescType.COMMAND_DESC_TITLE:
			pad.write(&x);
			break;
			default:
			{
				extring synopsis = extring.set_static_string("SYNOPSIS:\n\t");
				pad.write(&synopsis); // TODO put synopsis here
				pad.write(&x);
				Iterator<M100CommandOption> it = Iterator<M100CommandOption>.forFactory(&options, Replica_flags.ALL, 0, 0);
				while(it.next()) {
					M100CommandOption? opt = it.get();
					opt.desc(pad);
				}
			}
			break;
		}
		return 0;
	}
	public static xtring? rewrite(extring*cmd, HashTable<xtring,M100Variable?>*gVars) {
		// rewrite the command with args
		int rewritelen = cmd.length();
		rewritelen+= 512;
		extring rewritecmd = extring.stack(rewritelen);
		uchar p = '\0';
		int i;
		int len = cmd.length();
		int varStart = -1;
		extring varName = extring();
		for(i = 0; i < len; i++) {
			uchar x = cmd.char_at(i);
			if(varStart >= 0) {
				if(x == ')') {
					varName = extring.copy_deep(cmd);
					varName.truncate(i);
					varName.shift(varStart);
					varStart = -1;
					M100Variable?varVal = gVars.getProperty(&varName);
					if(varVal != null)varVal.concat(&rewritecmd);
					//print("var name %s[%d]\n", varName.to_string(), varName.length());
					varName.destroy();
				}
				continue;
			}
			if(p == '$' && (x - '0') >= 0 && (x - '0') <= 9 ) { // variable
				varName = extring.stack(2);
				varName.concat_char(x);
				varStart = -1;
				M100Variable?varVal = gVars.getProperty(&varName);
				if(varVal != null)varVal.concat(&rewritecmd);
				print("var name %s\n", varName.to_string());
				varName.destroy();
				x = 0; // eat x
			} else if(p == '$' && x == '$') {
				rewritecmd.concat_char(x);
				x = 0; // eat x
			} else if(p == '$' && x == '(') {
				varStart = i+1;
				x = 0; // eat x
			} else if(x == '$') {
				// do nothing ..
			} else {
				rewritecmd.concat_char(x);
			}
			p = x;
		}
		return new xtring.copy_deep(&rewritecmd);
	}

}
/** @}*/
