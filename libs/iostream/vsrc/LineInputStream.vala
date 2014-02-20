using aroop;
using shotodol;

public class shotodol.LineInputStream : InputStream {
	InputStream is;
	etxt rbuf;
	etxt rmem;
	public LineInputStream(InputStream down_stream) {
		is = down_stream;
		rmem = etxt.EMPTY();
		rbuf = etxt.EMPTY();
		rmem.buffer(128);
	}
	public override int available_bytes() throws IOStreamError.InputStreamError {
		return is.available_bytes();
	}
	public override int read(etxt*ln) throws IOStreamError.InputStreamError {
		if(rbuf.is_empty()) {
			rbuf.destroy();
			rbuf = etxt.same_same(&rmem);
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
