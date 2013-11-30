using aroop;
using shotodol;

public class shotodol.StandardOutputStream : OutputStream {
	public override int write(etxt*buf) throws IOStreamError.OutputStreamError {
		if(buf.is_zero_terminated()) {
			print(buf.to_string_magical());
		} else {
			//print("TODO buffer is not zero terminated\n");
			etxt dlg = etxt.stack_from_etxt(buf);
			print(dlg.to_string_magical());
		}
		return buf.length();
	}
}
