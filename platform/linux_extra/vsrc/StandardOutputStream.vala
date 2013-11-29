using aroop;
using shotodol;

public class shotodol.StandardOutputStream : OutputStream {
	public override int write(etxt*buf) throws IOStreamError.OutputStreamError {
		print(buf.to_string_magical());
		return buf.length();
	}
}
