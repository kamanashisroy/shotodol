using aroop;
using shotodol;

/** \addtogroup iostream
 *  @{
 */

public abstract class shotodol.StreamDescriptor : Replicable {
	public abstract OutputStream getOutputStream();
	public abstract InputStream getInputStream();
}
/** @}*/
