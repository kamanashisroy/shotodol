using aroop;
using shotodol;

public abstract class shotodol.Spindle : Replicable {
	public Spindle() {
	}
	public abstract int start(Spindle?plr);
	public abstract int step();
	public abstract int cancel();
}
