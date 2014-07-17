using aroop;
using shotodol;

/** \addtogroup iostream
 *  @{
 */
public class shotodol.BufferedOutputStream : OutputStream {
	estr cache;
	bool closed;
	public BufferedOutputStream(int sz) {
		cache = estr();
		cache.buffer(sz);
		closed = false;
	}
	public BufferedOutputStream.forCache(estr*gCache) {
		cache = estr.copy_shallow(gCache);
	}
	public void getAs(estr*content) {
		content.rebuild_and_copy_on_demand(&cache);
	}
	public int reset() {
		cache.trim_to_length(0);
		return 0;
	}
	public override int write(estr*buf) throws IOStreamError.OutputStreamError {
		if(closed) {
			return 0;
		}
		int len = buf.length();
		cache.concat(buf);
		return len;
	}
	public override void close() throws IOStreamError.OutputStreamError {
		closed = true;
		return;
	}
}
/** @}*/
