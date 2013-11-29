using aroop;
using shotodol;

public abstract class shotodol.Module : Replicable {
	protected etxt name;
	protected etxt version;
	public abstract int init();
	public abstract int deinit();
}

