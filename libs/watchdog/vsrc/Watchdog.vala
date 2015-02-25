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
	internal Watchdog.WatchdogSeverity severity;
	internal int subtype;
	internal int tag;
	xtring msg;
	internal WatchdogEntry(string gsourcefile, int glineno, int glevel, Watchdog.WatchdogSeverity gseverity, int gsubtype, int gtag, extring*gmsg, Factory<xtring>*xtringBuilder) {
		build(gsourcefile, glineno, glevel, gseverity, gsubtype, gtag, gmsg, xtringBuilder);
	}
	internal void build(string gsourcefile, int glineno, int glevel, Watchdog.WatchdogSeverity gseverity, int gsubtype, int gtag, extring*gmsg, Factory<xtring>*xtringBuilder) {
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

public class shotodol.Watchdog : Replicable {
	internal OutputStream? pad;
	internal static Watchdog? watch;
	public enum WatchdogSeverity {
		LOG = 0,
		DEBUG,
		NOTICE,
		WARNING,
		ERROR,
		ALERT;
		public unowned string to_string(WatchdogSeverity x) {
			switch(x) {
				case LOG:
					return "  ";
				case DEBUG:
					return "..";
				case NOTICE:
					return "--";
				case WARNING:
					return "!!";
				case ERROR:
					return "EE";
				case ALERT:
					return "AA";
			}
			return "  ";
		}
	}
	int numberOfOnMemoryLogs;
	ArrayList<WatchdogEntry> logs;
	Factory<WatchdogEntry>entryFactory;
	Factory<xtring>xtringFactory;
	int rotator;
	int logLevel;
	public Watchdog(OutputStream?logger, int givenNumberOfOnMemoryLogs) {
		pad = logger;
		numberOfOnMemoryLogs = givenNumberOfOnMemoryLogs;
		logs = ArrayList<WatchdogEntry>();
		entryFactory = Factory<WatchdogEntry>.for_type(16, 0, factory_flags.MEMORY_CLEAN);
		xtringFactory = Factory<xtring>.for_type_full(32, (uint)sizeof(xtring)+64);
		logLevel = 20;
		rotator = 0;
		watch = this;
	}
	~Watchdog() {
		logs.destroy(); // logs must be destroyed before factory
		entryFactory.destroy();
		xtringFactory.destroy(); // xtring must be destroyed after entry factory
	}
	public int stop() {
		watch = null;
		return 0;
	}
	public int dump(OutputStream outs, extring*sourcefile, int lineno, int level, int severity, int tag) {
		int i = 0;
		for(;i < numberOfOnMemoryLogs;i++) {
			int pos = i+rotator;
			pos = pos%numberOfOnMemoryLogs;
			WatchdogEntry ?x = logs.get(pos);
			if(x != null) {
				if(sourcefile != null && !sourcefile.equals(x.sourcefile)) {
					continue;
				}
				if(lineno != -1 && lineno != x.lineno) {
					continue;
				}
				if(level != -1 && x.level > level) {
					continue;
				}
				if(severity != -1 && severity != x.severity) {
					continue;
				}
				if(tag != -1 && tag != x.tag) {
					continue;
				}
				x.serialize(outs);
			}
		}
		return 0;
	}
	public static int watchvar_helper(extring*buf, extring*varname, extring*varval) {
		extring EQUALS = extring.set_static_string("=");
		extring header = extring.stack(8);
		buf.concat(varname);
		buf.concat(&EQUALS);
		header.printf("%d:", varval.length());
		buf.concat(&header);
		buf.concat(varval);
		return 0;
	}
	public static int watchvar(string sourcefile, int lineno, int level, WatchdogSeverity severity, int subtype, int tag, extring*varname, extring*varval) {
		extring buf = extring.stack(128);
		watchvar_helper(&buf, varname, varval);
		watchit(sourcefile, lineno, level, severity, subtype, tag, &buf);
		return 0;
	}
	public static int watchit(string sourcefile, int lineno, int level, WatchdogSeverity severity, int subtype, int tag, extring*msg) {
		if(watch == null || watch.logLevel < level) return 0;
		
		//WatchdogEntry x = new WatchdogEntry();
		WatchdogEntry x = watch.entryFactory.alloc_full();
		x.build(sourcefile, lineno, level, severity, subtype, tag, msg, &watch.xtringFactory);
		if(watch.pad != null) x.serialize(watch.pad);
		if(watch.numberOfOnMemoryLogs == 0) return 0;
		watch.logs.set(watch.rotator, x);
		watch.rotator = (watch.rotator+1)%watch.numberOfOnMemoryLogs;
		return 0;
	}
	public static int watchit_string(string sourcefile, int lineno, int level, WatchdogSeverity severity, int subtype, int tag, string data) {
		extring msg = extring.set_string(data);
		watchit(sourcefile, lineno, level, WatchdogSeverity.LOG, 0, 0, &msg);
		return 0;
	}
	public static int logString(string sourcefile, int lineno, int level, string st) {
		extring buf = extring.set_string(st);
		watchit(sourcefile, lineno, level, WatchdogSeverity.LOG, 0, 0, &buf);
		return 0;
	}
	public static int logInt(string sourcefile, int lineno, int level, string st, int val) {
		extring buf = extring.stack(128);
		buf.printf("%s:%d\n", st, val);
		watchit(sourcefile, lineno, level, WatchdogSeverity.LOG, 0, 0, &buf);
		return 0;
	}
#if false
	public static int logit(string input, ...) {
		var l = va_list();
		extring dlg = extring.stack(128);
		dlg.printf(input, l);
		logMsgDoNotUse(&dlg);
		return 0;
	}
#endif
	public static int reset(Watchdog?w) {
		watch = w;
		return 0;
	}
}
/** @}*/
