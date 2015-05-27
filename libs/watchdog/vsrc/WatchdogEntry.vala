using aroop;
using shotodol;

/**
 * \ingroup shotodol_library
 * \defgroup watchdog Watchdog to support debugging and reporting error
 * [Cohesion : Functional]
 */

/** \addtogroup watchdog
 *  @{
 */

internal class shotodol.WatchdogEntry : Replicable {
	internal xtring sourcefile;
	internal int lineno;
	internal int level;
	internal Watchdog.Severity severity;
	internal int subtype;
	internal int tag;
	xtring msg;
	internal WatchdogEntry(string gsourcefile, int glineno, int glevel, Watchdog.Severity gseverity, int gsubtype, int gtag, extring*gmsg, OPPFactory<xtring>*xtringBuilder) {
		build(gsourcefile, glineno, glevel, gseverity, gsubtype, gtag, gmsg, xtringBuilder);
	}
	internal void build(string gsourcefile, int glineno, int glevel, Watchdog.Severity gseverity, int gsubtype, int gtag, extring*gmsg, OPPFactory<xtring>*xtringBuilder) {
		//extring sf = extring.stack(64);
		//sf.concat_string(gsourcefile);
		sourcefile = new xtring.copy_string(gsourcefile);
		if(sourcefile != null)sourcefile.fly().zero_terminate();
		lineno = glineno;
		level = glevel;
		severity = gseverity;
		subtype = gsubtype;
		tag = gtag;
		msg = new xtring.copy_content(gmsg.to_string(), gmsg.length()+2, xtringBuilder);
		// trim new line
		if(msg.fly().length() >= 1 && msg.fly().char_at(msg.fly().length()-1) == '\n') {
			msg.fly().truncate(msg.fly().length()-1);
		} else if(msg.fly().length() >= 2 && msg.fly().char_at(msg.fly().length()-2) == '\n' && msg.fly().char_at(msg.fly().length()-1) == '\0') {
			msg.fly().truncate(msg.fly().length()-2);
		} else if(msg.fly().length() >= 3 && msg.fly().char_at(msg.fly().length()-3) == '\n' && msg.fly().char_at(msg.fly().length()-2) == '\0') {
			msg.fly().truncate(msg.fly().length()-3);
		}
		msg.fly().zero_terminate();
	}

	internal void serialize(OutputStream strm) {
		extring fullmsg = extring.stack(msg.fly().length()+128);
		fullmsg.printf("[%20.10s %-5d][%s][%d] %s\n", sourcefile.fly().to_string(), lineno, severity.to_string(severity), tag, msg.fly().to_string());
		strm.write(&fullmsg);
	}
}

/** @}*/
