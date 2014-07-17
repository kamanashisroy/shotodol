using aroop;
using shotodol;

/** \addtogroup linux_extra
 *  @{
 */
public class shotodol.StandardOutputStream : OutputStream {
	public override int write(estr*buf) throws IOStreamError.OutputStreamError {
		if(buf.is_zero_terminated()) {
			print(buf.to_string_magical());
		} else {
			estr dlg = estr.stack_copy_deep(buf);
			dlg.zero_terminate();
			print(dlg.to_string_magical());
		}
		return buf.length();
	}
}
/* @} */
