using aroop;
using shotodol;

/** \addtogroup console
 *  @{
 */

internal class ConsoleHistory : ConsoleSpindle {
	enum Conf {
		HIGHEST_HISTORY_BACKUP = 100,
	}
	ArrayList<xtring> history;
	int historyIndex = 0;
	int counter = 0;
	public ConsoleHistory() {
		base();
		history = ArrayList<xtring>();
		historyIndex = 0;
		counter = 0;
	}

	public override void addHistory(extring*cmd) {
		xtring? myCmd = new xtring.copy_on_demand(cmd);
		counter = (counter+1) % Conf.HIGHEST_HISTORY_BACKUP;
		history.set(counter, myCmd);
	}

	public override void showHistory() {
		xtring? old = null;
		int i = 0;
		for(i = historyIndex; i < Conf.HIGHEST_HISTORY_BACKUP;i++) {
			int index = Conf.HIGHEST_HISTORY_BACKUP + counter - i;
			index = index % Conf.HIGHEST_HISTORY_BACKUP;
			old = history.get(index);
			if(old != null) {
				historyIndex = i;
				pad.write(old);
				break;
			}
		}
	}

	public void showHistoryFull() {
		int i = 0;
		extring dlg = extring.stack(128);
		for(; i < Conf.HIGHEST_HISTORY_BACKUP;i++) {
			xtring? old = null;
			int index = Conf.HIGHEST_HISTORY_BACKUP + counter - i;
			index = index % Conf.HIGHEST_HISTORY_BACKUP;
			old = history.get(index);
			if(old != null) {
				dlg.printf("[%d] %s\n", index, old.fly().to_string());
				pad.write(&dlg);
			}
		}
	}

	public xtring? getHistory(int i) {
		return history.get(i);
	}

	~ConsoleHistory() {
		history.destroy();
	}
}
/* @} */
