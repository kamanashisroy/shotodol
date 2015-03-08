using aroop;
using shotodol;

/** \addtogroup make100
 *  @{
 */
internal errordomain shotodol.M100CommandOptionError.ParseError {
	MISSING_ARGUMENT,
}
public class shotodol.M100CommandOption : Searchable {
	xtring prefix;
	xtring elab;
	M100Command.OptionType tp;
	aroop_hash hash;
	
	internal void build(extring*pre, M100Command.OptionType opt_type, aroop_hash id, extring*help) {
		core.assert(prefix == null && elab == null);
		xtring p = new xtring.copy_on_demand(pre);
		xtring h = new xtring.copy_on_demand(help);
		build2(p, opt_type, id, h);
	}
	internal void build2(xtring pre, M100Command.OptionType opt_type, aroop_hash id, xtring help) {
		core.assert(prefix == null && elab == null);
		prefix = pre;
		elab = help;
		tp = opt_type;
		hash = id;
		set_hash(prefix.fly().getStringHash());
	}
	internal int desc(OutputStream pad) {
		extring tpText = extring.stack(16);
		tp.asText(&tpText);
		tpText.zero_terminate();
		extring x = extring.stack(128);
		x.printf("\t%10.10s\t\t%10.10s\t%s\n", prefix.fly().to_string(), tpText.to_string(),  elab.fly().to_string());
		pad.write(&x);
		return 0;
	}
	internal static int parseOptions(extring*cmdstr, ArrayList<xtring>*val, SearchableOPPFactory<M100CommandOption>*opts) throws M100CommandOptionError.ParseError {
		extring token = extring();
		extring inp = extring.stack_copy_deep(cmdstr);
		while(true) {
			LineAlign.next_token(&inp, &token);
			if(token.is_empty_magical()) {
				break;
			}
			if(token.char_at(0) != '-') {
				continue;
			}
			M100CommandOption? opt = opts.search(token.getStringHash(), null);
			if(opt == null) {
				// TODO say unknown option
				continue;
			}
			if(token.equals((aroop.extring*)opt.prefix)) {
				if(opt.tp == M100Command.OptionType.TXT) {
					LineAlign.next_token(&inp, &token);
					if(token.is_empty_magical() || token.char_at(0) == '-') {
						//it.destroy();
						throw new M100CommandOptionError.ParseError.MISSING_ARGUMENT("Expected text value here");
					}
					xtring x = new xtring.copy_on_demand(&token);
					//val.add_container(x, opt.hash);
					val.set(opt.hash,x);
				} else if(opt.tp == M100Command.OptionType.INT) {
					LineAlign.next_token(&inp, &token);
					if(token.is_empty_magical() || (token.char_at(0) - '0') > 9) {
						//it.destroy();
						throw new M100CommandOptionError.ParseError.MISSING_ARGUMENT("Expected decimal value here");
					}
					xtring x = new xtring.copy_on_demand(&token);
					val.set(opt.hash,x);
					//val.add_container(x, opt.hash);
				} else if(opt.tp == M100Command.OptionType.NONE) {
					//val.add_container(xtring.BLANK_STRING, opt.hash);
					val.set(opt.hash, xtring.BLANK_STRING);
				}
			}
		}
		return 0;
	}
	
	public M100Command.OptionType getType() {
		return tp;
	}
	public void getPrefixAs(extring*outvar) {
		outvar.rebuild_and_copy_shallow(prefix);
	}
}
/** @}*/
