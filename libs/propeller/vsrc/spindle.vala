using aroop;
using shotodol;

public abstract class shotodol.Spindle : Replicable {
	public Spindle() {
	}
	protected abstract int start(Propeller?plr);
	protected abstract int step();
	public abstract int cancel();
}
