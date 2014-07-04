using aroop;
using shotodol;

/** \addtogroup make100
 *  @{
 */
internal errordomain shotodol.M100CommandOptionError.ParseError {
	MISSING_ARGUMENT,
}
internal class shotodol.M100CommandOption : Searchable {
	txt prefix;
	txt elab;
	M100Command.OptionType tp;
	aroop_hash hash;
	
	internal void build(etxt*pre, M100Command.OptionType opt_type, aroop_hash id, etxt*help) {
		core.assert(prefix == null && elab == null);
		txt p = new txt.memcopy_etxt(pre);
		txt h = new txt.memcopy_etxt(help);
		build2(p, opt_type, id, h);
	}
	internal void build2(txt pre, M100Command.OptionType opt_type, aroop_hash id, txt help) {
		core.assert(prefix == null && elab == null);
		prefix = pre;
		elab = help;
		tp = opt_type;
		hash = id;
		set_hash(prefix.getStringHash());
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
	internal static int parseOptions(etxt*cmdstr, ArrayList<txt>*val, SearchableFactory<M100CommandOption>*opts) throws M100CommandOptionError.ParseError {
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
			M100CommandOption? opt = opts.search(token.getStringHash(), null);
			if(opt == null) {
				// TODO say unknown option
				continue;
			}
			if(token.equals((aroop.etxt*)opt.prefix)) {
				if(opt.tp == M100Command.OptionType.TXT) {
					LineAlign.next_token(&inp, &token);
					if(token.is_empty_magical() || token.char_at(0) == '-') {
						//it.destroy();
						throw new M100CommandOptionError.ParseError.MISSING_ARGUMENT("Expected text value here");
					}
					txt x = new txt.memcopy_etxt(&token);
					//val.add_container(x, opt.hash);
					val.set(opt.hash,x);
				} else if(opt.tp == M100Command.OptionType.INT) {
					LineAlign.next_token(&inp, &token);
					if(token.is_empty_magical() || (token.char_at(0) - '0') > 9) {
						//it.destroy();
						throw new M100CommandOptionError.ParseError.MISSING_ARGUMENT("Expected decimal value here");
					}
					txt x = new txt.memcopy_etxt(&token);
					val.set(opt.hash,x);
					//val.add_container(x, opt.hash);
				} else if(opt.tp == M100Command.OptionType.NONE) {
					//val.add_container(txt.BLANK_STRING, opt.hash);
					val.set(opt.hash, txt.BLANK_STRING);
				}
			}
		}
		return 0;
	}
}
/** @}*/
