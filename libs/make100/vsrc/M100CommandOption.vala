using aroop;
using shotodol;

/** \addtogroup make100
 *  @{
 */
internal errordomain shotodol.M100CommandOptionError.ParseError {
	MISSING_ARGUMENT,
}
internal class shotodol.M100CommandOption : Replicable {
	txt prefix;
	txt elab;
	M100Command.OptionType tp;
	aroop_hash hash;
	
	internal void build(etxt*pre, M100Command.OptionType opt_type, aroop_hash id, etxt*help) {
		prefix = new txt.memcopy_etxt(pre);
		elab = new txt.memcopy_etxt(help);
		tp = opt_type;
		hash = id;
	}
	internal int desc(OutputStream pad) {
		etxt tpText = etxt.stack(16);
		tp.asText(&tpText);
		tpText.zero_terminate();
		etxt x = etxt.stack(128);
		x.printf("\t%10.10s\t\t%10.10s\t%s\n", prefix.to_string(), tpText.to_string(),  elab.to_string());
		pad.write(&x);
		return 0;
	}
	internal static int parseOptions(etxt*cmdstr, SearchableSet<txt>*val, Factory<M100CommandOption>*opts) throws M100CommandOptionError.ParseError {
		etxt token = etxt.EMPTY();
		etxt inp = etxt.stack_from_etxt(cmdstr);
		while(true) {
			LineAlign.next_token(&inp, &token);
			if(token.is_empty_magical()) {
				break;
			}
			if(token.char_at(0) != '-') {
				continue;
			}
			Iterator<M100CommandOption> it = Iterator<M100CommandOption>(opts, Replica_flags.ALL, 0, 0);
			while(it.next()) {
				M100CommandOption? opt = it.get();
				//print("matching %s %s\n", token.to_string(), opt.prefix.to_string());
				if(token.equals((aroop.etxt*)opt.prefix)) {
					if(opt.tp == M100Command.OptionType.TXT) {
						LineAlign.next_token(&inp, &token);
						if(token.is_empty_magical() || token.char_at(0) == '-') {
							it.destroy();
							throw new M100CommandOptionError.ParseError.MISSING_ARGUMENT("Expected text value here");
						}
						txt x = new txt.memcopy_etxt(&token);
						val.add_container(x, opt.hash);
					} else if(opt.tp == M100Command.OptionType.INT) {
						LineAlign.next_token(&inp, &token);
						if(token.is_empty_magical() || (token.char_at(0) - '0') > 9) {
							it.destroy();
							throw new M100CommandOptionError.ParseError.MISSING_ARGUMENT("Expected decimal value here");
						}
						txt x = new txt.memcopy_etxt(&token);
						val.add_container(x, opt.hash);
					} else if(opt.tp == M100Command.OptionType.NONE) {
						val.add_container(txt.BLANK_STRING, opt.hash);
					}
				}
			}
			it.destroy();
		}
		return 0;
	}
}
/** @}*/
