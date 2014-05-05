using aroop;
using shotodol;

/** \addtogroup iostream
 *  @{
 */
public class shotodol.BufferedOutputStream : OutputStream {
	etxt cache;
	bool closed;
	public BufferedOutputStream(int sz) {
		cache = etxt.EMPTY();
		cache.buffer(sz);
		closed = false;
	}
	public BufferedOutputStream.forCache(etxt*gCache) {
		cache = etxt.same_same(gCache);
	}
	public void getAs(etxt*content) {
		content.destroy();
		(*content) = etxt.same_same(&cache);
	}
	public int reset() {
		cache.trim_to_length(0);
		return 0;
	}
	public override int write(etxt*buf) throws IOStreamError.OutputStreamError {
		if(closed) {
			return 0;
		}
		int len = buf.length();
		cache.concat(buf);
		buf.shift(len-1);
		return len;
	}
	public override void close() throws IOStreamError.OutputStreamError {
		closed = true;
		return;
	}
}
/** @}*/
