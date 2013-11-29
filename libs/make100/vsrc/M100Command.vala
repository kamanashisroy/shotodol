using aroop;
using shotodol;

public abstract class shotodol.M100Command : Replicable {
	public enum CommandDescType {
		COMMAND_DESC_TITLE,
		COMMAND_DESC_FULL,
	}
	public enum OptionType {
		TXT,
		NONE,
	}
	//public etxt?cmdprefix;
	Factory<M100CommandOption> options;
	public M100Command() {
		options = Factory<M100CommandOption>.for_type();
	}
	
	~M100Command() {
		options.destroy();
	}
	public int match_all(container<txt> can) {
		return 0;
	}
	public void addOption(etxt*prefix, OptionType tp, aroop_hash id, etxt*help) {
		M100CommandOption opt = options.alloc_full();
		opt.pin();
		opt.build(prefix, tp, id, help);
	}
	
	public int parseOptions(etxt*cmdstr, SearchableSet<txt>*val) {
		M100CommandOption.parseOptions(cmdstr, val, &options);
		return 0;
	}
	
	public void greet(OutputStream pad) {
		etxt greetings = etxt.stack(128);
		greetings.printf("<%s> -----------------------------------------------------------------\n" , get_prefix().to_string());
		pad.write(&greetings);
	} 
	
	public virtual etxt*get_prefix() {
		return null;
	}
	public virtual int act_on(etxt*cmdstr, OutputStream pad) {
		return 0;
	}
	public virtual int desc(CommandDescType tp, OutputStream pad) {
		etxt x = etxt.stack(32);
		x.printf("%s\n", get_prefix().to_string());
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
}
