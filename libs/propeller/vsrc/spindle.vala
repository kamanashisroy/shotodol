using aroop;
using shotodol;

public abstract class shotodol.Spindle : Replicable {
	public Spindle() {
	}
	public abstract int start(Propeller?plr);
	public abstract int step();
	public abstract int cancel();
}
