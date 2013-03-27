using aroop;
using shotodol;

public class shotodol.Command : Replicable {
	//public etxt?cmdprefix;
	public virtual etxt*get_prefix() {
		return null;
	}
	public virtual int act_on(/*ArrayList<txt> tokens*/etxt*cmdstr, StandardIO io) {
		return 0;
	}
}
