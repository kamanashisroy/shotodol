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

public class shotodol.Watchdog : Replicable {
	internal OutputStream? pad;
	internal static Watchdog? watch;
	public enum Severity {
		LOG = 0,
		DEBUG,
		NOTICE,
		WARNING,
		ERROR,
		ALERT;
		public unowned string to_string(Severity x) {
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
	OPPFactory<WatchdogEntry>entryPool;
	OPPFactory<xtring>xtringPool;
	int rotator;
	int logLevel;
	public Watchdog(OutputStream?logger, int givenNumberOfOnMemoryLogs) {
		pad = logger;
		numberOfOnMemoryLogs = givenNumberOfOnMemoryLogs;
		logs = ArrayList<WatchdogEntry>();
		entryPool = OPPFactory<WatchdogEntry>.for_type(16, 0, factory_flags.MEMORY_CLEAN);
		xtringPool = OPPFactory<xtring>.for_type_full(32, (uint)sizeof(xtring)+64);
		logLevel = 20;
		rotator = 0;
		watch = this;
	}
	~Watchdog() {
		logs.destroy(); // logs must be destroyed before factory
		entryPool.destroy();
		xtringPool.destroy(); // xtring must be destroyed after entry factory
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
	public static int watchvar(string sourcefile, int lineno, int level, Severity severity, int subtype, int tag, extring*varname, extring*varval) {
		extring buf = extring.stack(128);
		watchvar_helper(&buf, varname, varval);
		watchit(sourcefile, lineno, level, severity, subtype, tag, &buf);
		return 0;
	}
	public static int watchit(string sourcefile, int lineno, int level, Severity severity, int subtype, int tag, extring*msg) {
		if(watch == null || watch.logLevel < level) return 0;
		
		//WatchdogEntry x = new WatchdogEntry();
		WatchdogEntry x = watch.entryPool.alloc_full();
		x.build(sourcefile, lineno, level, severity, subtype, tag, msg, &watch.xtringPool);
		if(watch.pad != null) x.serialize(watch.pad);
		if(watch.numberOfOnMemoryLogs == 0) return 0;
		watch.logs.set(watch.rotator, x);
		watch.rotator = (watch.rotator+1)%watch.numberOfOnMemoryLogs;
		return 0;
	}
	public static int watchit_string(string sourcefile, int lineno, int level, Severity severity, int subtype, int tag, string data) {
		extring msg = extring.set_string(data);
		watchit(sourcefile, lineno, level, Severity.LOG, 0, 0, &msg);
		return 0;
	}
	public static int logString(string sourcefile, int lineno, int level, string st) {
		extring buf = extring.set_string(st);
		watchit(sourcefile, lineno, level, Severity.LOG, 0, 0, &buf);
		return 0;
	}
	public static int logInt(string sourcefile, int lineno, int level, string st, int val) {
		extring buf = extring.stack(128);
		buf.printf("%s:%d\n", st, val);
		watchit(sourcefile, lineno, level, Severity.LOG, 0, 0, &buf);
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
