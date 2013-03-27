using aroop;
using shotodol;

public abstract class shotodol.InputStream : Replicable {
	public abstract int available_bytes();
	public abstract int read(etxt*buf);
	public abstract bool rewind();
}
