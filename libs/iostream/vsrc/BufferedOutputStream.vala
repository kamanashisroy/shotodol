using aroop;
using shotodol;

/** \addtogroup iostream
 *  @{
 */
public class shotodol.BufferedOutputStream : OutputStream {
	extring cache;
	bool closed;
	public BufferedOutputStream(int sz) {
		cache = extring();
		cache.rebuild_in_heap(sz);
		closed = false;
	}
	public BufferedOutputStream.forCache(extring*gCache) {
		cache = extring.copy_shallow(gCache);
	}
	public void getAs(extring*content) {
		content.rebuild_and_copy_on_demand(&cache);
	}
	public int reset() {
		cache.trim_to_length(0);
		return 0;
	}
	public override int write(extring*buf) throws IOStreamError.OutputStreamError {
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
