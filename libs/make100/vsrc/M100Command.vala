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
		public void asText(estr*buf) {
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
	estr prfx;
	SearchableFactory<M100CommandOption> options;
	public M100Command(estr*prefix) {
		options = SearchableFactory<M100CommandOption>.for_type(4, 1, factory_flags.SWEEP_ON_UNREF | factory_flags.EXTENDED | factory_flags.SEARCHABLE | factory_flags.MEMORY_CLEAN);
		prfx = estr.copy_on_demand(prefix);
	}
	
	~M100Command() {
		prfx.destroy();
		options.destroy();
	}

#if false
	public int match_all(container<str> can) {
		return 0;
	}
#endif
	public void addOption(estr*prefix, OptionType tp, aroop_hash id, estr*help) {
		M100CommandOption opt = options.alloc_full();
		opt.pin();
		opt.build(prefix, tp, id, help);
	}

	public void addOptionString(string pre, OptionType tp, aroop_hash id, string he) {
		str prefix = new str.copy_string(pre);
		str help = new str.copy_string(he);
		M100CommandOption opt = options.alloc_full();
		opt.pin();
		opt.build2(prefix, tp, id, help);
	}
	
	public int parseOptions(estr*cmdstr, ArrayList<str>*val) {
		try {
			M100CommandOption.parseOptions(cmdstr, val, &options);
		} catch(M100CommandOptionError.ParseError e) {
			// TODO say error while parsing ..
			return -1;
		}
		return 0;
	}

	public virtual void greet(OutputStream pad) {
		estr greetings = estr.stack(128);
		greetings.printf("<%16s> -----------------------------------------------------------------\n" , getPrefix().to_string());
		pad.write(&greetings);
	} 
	public virtual void bye(OutputStream pad, bool success) {
		estr byebye = estr.stack(128);
		byebye.printf("<%16s> -----------------------------------------------------------------\n" , success?"Successful":"Failed");
		pad.write(&byebye);
		if(!success)
		desc(CommandDescType.COMMAND_DESC_FULL, pad);
	} 
	
	public estr*getPrefix() {
		return &prfx;
	}
	public virtual int act_on(estr*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		return 0;
	}
	public virtual int desc(CommandDescType tp, OutputStream pad) {
		estr x = estr.stack(32);
		x.printf("%s\n", getPrefix().to_string());
		switch(tp) {
			case CommandDescType.COMMAND_DESC_TITLE:
			pad.write(&x);
			break;
			default:
			{
				pad.write(&x);
				Iterator<M100CommandOption> it = Iterator<M100CommandOption>(&options, Replica_flags.ALL, 0, 0);
				while(it.next()) {
					M100CommandOption? opt = it.get();
					opt.desc(pad);
				}
			}
			break;
		}
		return 0;
	}
	public static str? rewrite(estr*cmd, HashTable<M100Variable?>*gVars) {
		// rewrite the command with args
		int rewritelen = cmd.length();
		rewritelen+= 512;
		estr rewritecmd = estr.stack(rewritelen);
		char p = '\0';
		int i;
		int len = cmd.length();
		int varStart = -1;
		estr varName = estr();
		for(i = 0; i < len; i++) {
			char x = cmd.char_at(i);
			if(varStart >= 0) {
				if(x == ')') {
					varName = estr.copy_deep(cmd);
					varName.trim_to_length(i);
					varName.shift(varStart);
					varStart = -1;
					M100Variable?varVal = gVars.get(&varName);
					if(varVal != null)varVal.concat(&rewritecmd);
					//print("var name %s[%d]\n", varName.to_string(), varName.length());
					varName.destroy();
				}
				continue;
			}
			if(p == '$' && (x - '0') >= 0 && (x - '0') <= 9 ) { // variable
				varName = estr.stack(2);
				varName.concat_char(x);
				varStart = -1;
				M100Variable?varVal = gVars.get(&varName);
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
		return new str.copy_deep(&rewritecmd);
	}

}
/** @}*/
