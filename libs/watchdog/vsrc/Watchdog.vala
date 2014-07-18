using aroop;
using shotodol;

/**
 * \ingroup library
 * \defgroup watchdog Watchdog to support debugging and reporting error(watchdog)
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
	internal int id;
	xtring msg;
	internal WatchdogEntry(string gsourcefile, int glineno, int glevel, Watchdog.WatchdogSeverity gseverity, int gsubtype, int gid, extring*gmsg) {
		//extring sf = extring.stack(64);
		//sf.concat_string(gsourcefile);
		sourcefile = new xtring.copy_string(gsourcefile);
		if(sourcefile != null)sourcefile.ecast().zero_terminate();
		lineno = glineno;
		level = glevel;
		severity = gseverity;
		subtype = gsubtype;
		id = gid;
		msg = new xtring.copy_content(gmsg.to_string(), gmsg.length()+2);
		// trim new line
		if(msg.ecast().length() >= 1 && msg.ecast().char_at(msg.ecast().length()-1) == '\n') {
			msg.ecast().trim_to_length(msg.ecast().length()-1);
		} else if(msg.ecast().length() >= 2 && msg.ecast().char_at(msg.ecast().length()-2) == '\n' && msg.ecast().char_at(msg.ecast().length()-1) == '\0') {
			msg.ecast().trim_to_length(msg.ecast().length()-2);
		} else if(msg.ecast().length() >= 3 && msg.ecast().char_at(msg.ecast().length()-3) == '\n' && msg.ecast().char_at(msg.ecast().length()-2) == '\0') {
			msg.ecast().trim_to_length(msg.ecast().length()-3);
		}
		msg.ecast().zero_terminate();
	}

	internal void serialize(OutputStream strm) {
		extring fullmsg = extring.stack(msg.ecast().length()+128);
		fullmsg.printf("[%20.10s %-5d][%s] %s\n", sourcefile.ecast().to_string(), lineno, severity.to_string(severity), msg.ecast().to_string());
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
	int rotator;
	int logLevel;
	public Watchdog(OutputStream?logger, int givenNumberOfOnMemoryLogs) {
		pad = logger;
		numberOfOnMemoryLogs = givenNumberOfOnMemoryLogs;
		logs = ArrayList<WatchdogEntry>();
		logLevel = 20;
		rotator = 0;
		watch = this;
	}
	public int stop() {
		watch = null;
		return 0;
	}
	public int dump(OutputStream outs, extring*sourcefile, int lineno, int level, int severity) {
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
	public static int watchvar(string sourcefile, int lineno, int level, WatchdogSeverity severity, int subtype, int id, extring*varname, extring*varval) {
		extring buf = extring.stack(128);
		watchvar_helper(&buf, varname, varval);
		watchit(sourcefile, lineno, level, severity, subtype, id, &buf);
		return 0;
	}
	public static int watchit(string sourcefile, int lineno, int level, WatchdogSeverity severity, int subtype, int id, extring*msg) {
		if(watch == null || watch.logLevel < level) return 0;
		
		WatchdogEntry x = new WatchdogEntry(sourcefile, lineno, level, severity, subtype, id, msg);
		if(watch.pad != null) x.serialize(watch.pad);
		if(watch.numberOfOnMemoryLogs == 0) return 0;
		watch.logs.set(watch.rotator, x);
		watch.rotator = (watch.rotator+1)%watch.numberOfOnMemoryLogs;
		return 0;
	}
	public static int watchit_string(string sourcefile, int lineno, int level, WatchdogSeverity severity, int subtype, int id, string data) {
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
