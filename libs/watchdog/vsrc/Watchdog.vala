using aroop;
using shotodol;

/**
 * \ingroup library
 * \defgroup watchdog Watchdog to support debugging and reporting error(watchdog)
 */

/** \addtogroup watchdog
 *  @{
 */
public class shotodol.Watchdog : Replicable {
	internal OutputStream? pad;
	internal static Watchdog? watch;
	public enum WatchdogSeverity {
		LOG = 0,
		DEBUG,
		NOTICE,
		WARNING,
		ERROR,
		ALERT,
	}
	int numberOfOnMemoryLogs;
	ArrayList<txt> logs;
	int rotator;
	public Watchdog(OutputStream?logger, int givenNumberOfOnMemoryLogs) {
		pad = logger;
		numberOfOnMemoryLogs = givenNumberOfOnMemoryLogs;
		logs = ArrayList<txt>();
		rotator = 0;
		watch = this;
	}
	public int stop() {
		watch = null;
		return 0;
	}
	public int dump(OutputStream outs) {
		int i = 0;
		for(;i < numberOfOnMemoryLogs;i++) {
			int pos = i+rotator;
			pos = pos%numberOfOnMemoryLogs;
			txt ?log = logs.get(pos);
			if(log != null) {
				outs.write(log);
			}
		}
		return 0;
	}
	public static int watchvar_helper(etxt*buf, etxt*varname, etxt*varval) {
		etxt EQUALS = etxt.from_static("=");
		etxt NEW_LINE = etxt.from_static("\n");
		etxt header = etxt.stack(8);
		buf.concat(varname);
		buf.concat(&EQUALS);
		header.printf("%d:", varval.length());
		buf.concat(&header);
		buf.concat(varval);
		buf.concat(&NEW_LINE);
		return 0;
	}
	public static int watchvar(string sourcefile, int lineno, WatchdogSeverity severity, int subtype, int id, etxt*varname, etxt*varval) {
		etxt buf = etxt.stack(128);
		watchvar_helper(&buf, varname, varval);
		watchit(sourcefile, lineno, severity, subtype, id, &buf);
		return 0;
	}
	public static int watchit(string sourcefile, int lineno, WatchdogSeverity severity, int subtype, int id, etxt*msg) {
		if(watch == null) return 0;
		txt fullmsg = new txt(null, msg.length()+128);
		msg.zero_terminate();
		fullmsg.printf("[%20.10s %-5d][%s] %s", sourcefile, lineno, "!!", msg.to_string());
		if(watch.pad != null)
			watch.pad.write(fullmsg);
		if(watch.numberOfOnMemoryLogs == 0) return 0;
		watch.logs.set(watch.rotator, fullmsg);
		watch.rotator = (watch.rotator+1)%watch.numberOfOnMemoryLogs;
		return 0;
	}
	public static int logMsgDoNotUse(string sourcefile, int lineno, etxt*msg) {
		watchit(sourcefile, lineno, WatchdogSeverity.LOG, 0, 0, msg);
		return 0;
	}
	public static int logString(string sourcefile, int lineno, string st) {
		etxt buf = etxt.stack(128);
		buf.printf("%s", st);
		watchit(sourcefile, lineno, WatchdogSeverity.LOG, 0, 0, &buf);
		return 0;
	}
#if false
	public static int logit(string input, ...) {
		var l = va_list();
		etxt dlg = etxt.stack(128);
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
