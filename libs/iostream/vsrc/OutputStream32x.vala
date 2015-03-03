using aroop;
using shotodol;

/** \addtogroup iostream
 *  @{
 */
public class shotodol.OutputStream32x : OutputStream {
	bool closed;
	protected aroop_uword16 count;
	protected OutputStream sink[64];
	public OutputStream32x() {
		closed = false;
	}
	~OutputStream32x() {
	}

	public int addOutputStream(OutputStream ostrm) {
		if(closed)
			return 0;
		if(count >= 64)
			return -1;
		//sink[count++] = ostrm;
		sink[count] = ostrm;
		count++;
		return (int)count-1;
	}

	public OutputStream? getOutputStream(aroop_uword16 token) {
		if(closed || token >= count)
			return null;
		return sink[token];
	}

	public override int write(extring*buf) throws IOStreamError.OutputStreamError {
		if(closed)
			return 0;
		int len = buf.length();
		if(len <= 2)
			return len;
		aroop_uword16 token = buf.char_at(0);
		token = token << 8;
		token |= buf.char_at(1);
		buf.shift(2);
		OutputStream? ostrm = getOutputStream(token);
		if(ostrm == null) 
			return -1;
		return ostrm.write(buf) + 2;
	}

	public override void close() throws IOStreamError.OutputStreamError {
		if(closed)return;
		closed = true;
		int i = 0;
		for(i = 0; i < count; i++) {
			sink[i] = null;
		}
	}
}


/* @} */
