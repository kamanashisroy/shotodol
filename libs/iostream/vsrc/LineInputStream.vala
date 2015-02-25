using aroop;
using shotodol;

/** \addtogroup iostream
 *  @{
 */
public class shotodol.LineInputStream : InputStream {
	InputStream downInputStream;
	extring rbuf;
	extring rmem;
	bool skipBlankLine;
	public LineInputStream.full(bool givenSkipBlankLine = true, int bufferSize = 1024, InputStream givenDownStream) {
		downInputStream = givenDownStream;
		rmem = extring();
		rbuf = extring();
		rmem.rebuild_in_heap(bufferSize);
		skipBlankLine = givenSkipBlankLine;
	}
	public LineInputStream(InputStream givenDownStream) {
		LineInputStream.full(true, 1024, givenDownStream);
	}
	public override int availableBytes() throws IOStreamError.InputStreamError {
		return downInputStream.availableBytes();
	}
	public override int readChar(extring*buf, bool dry) throws IOStreamError.InputStreamError {
		return downInputStream.readChar(buf, dry);
	}
	public override int read(extring*ln) throws IOStreamError.InputStreamError {
		if(rbuf.is_empty()) {
			rbuf.destroy();
			rbuf = extring.copy_shallow(&rmem);
			rmem.truncate(0);
			if(downInputStream.read(&rbuf) == 0) {
				return 0;
			}
		}
		int i = 0;
		int ln_start = 0;
		int retlen = 0;
		for(i=0;i<rbuf.length();i++) {
			if(rbuf.char_at(i) == '\n') {
				if(i - ln_start <= 1) {
					if((i - ln_start == 0) || rbuf.char_at(ln_start) == '\r') {
						// skip blank line
						if(skipBlankLine) {
							ln_start = i+1;
						}
						continue;
					}
				}
				int prelen = ln.length();
				int lnlen = i-ln_start;
				rbuf.shift(ln_start);
				ln.concat(&rbuf);
				ln.truncate(prelen + lnlen);
				retlen = i - ln_start;
				rbuf.shift(lnlen+1);
				ln_start = 0;
				break;
			}
		}
		rbuf.shift(ln_start);
#if false
		ln.zero_terminate();
		print("ln[%s]\n", ln.to_string());
		rbuf.zero_terminate();
		print("rbuf[%s]\n", rbuf.to_string());
#endif
		if(retlen == 0) {
			rmem.concat(&rbuf); // memory move
			rbuf.truncate();
			return read(ln);
		}
		return retlen;
	}
	public override bool rewind() throws IOStreamError.InputStreamError {
		return rewind();
	}
	public override void close() throws IOStreamError.InputStreamError {
		downInputStream.close();
	}
}
/** @}*/
