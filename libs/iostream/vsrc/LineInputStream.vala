using aroop;
using shotodol;

/** \addtogroup iostream
 *  @{
 */
public class shotodol.LineInputStream : InputStream {
	InputStream is;
	extring rbuf;
	extring rmem;
	public LineInputStream(InputStream down_stream, int bufferSize = 1024) {
		is = down_stream;
		rmem = extring();
		rbuf = extring();
		rmem.buffer(bufferSize);
	}
	public override int availableBytes() throws IOStreamError.InputStreamError {
		return is.availableBytes();
	}
	public override int readChar(extring*buf, bool dry) throws IOStreamError.InputStreamError {
		return is.readChar(buf, dry);
	}
	public override int read(extring*ln) throws IOStreamError.InputStreamError {
		if(rbuf.is_empty()) {
			rbuf.destroy();
			rbuf = extring.copy_shallow(&rmem);
			rmem.trim_to_length(0);
			if(is.read(&rbuf) == 0) {
				return 0;
			}
		}
		int i = 0;
		int ln_start = 0;
		int retlen = 0;
		for(i=0;i<rbuf.length();i++) {
			if(rbuf.char_at(i) == '\n') {
				if(i - ln_start == 0) {
					// skip blank line
					ln_start++;
					continue;
				}
				ln.concat(&rbuf);
				ln.trim_to_length(i);
				retlen = i - ln_start;
				if(ln_start != 0) {
					ln.shift(ln_start);
				}
				ln_start = i+1;
				break;
			}
		}
		rbuf.shift(ln_start);
		if(retlen == 0) {
			rmem.concat(&rbuf); // memory move
			rbuf.trim_to_length(0);
			return read(ln);
		}
		return retlen;
	}
	public override bool rewind() throws IOStreamError.InputStreamError {
		return rewind();
	}
	public override void close() throws IOStreamError.InputStreamError {
		is.close();
	}
}
/** @}*/
