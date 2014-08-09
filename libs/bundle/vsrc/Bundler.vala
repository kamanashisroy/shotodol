using aroop;
using shotodol;

/**
 * // C code
 * struct {
 *  unsigned char key;
 *  unsigned int type:2;
 *  unsigned int len:6;
 *  char data[4];
 * };
 *
 * */

/**
 * \ingroup library
 * \defgroup bundle Data serialization support(bundle)
 * [Cohesion : Functional]
 */

/** \addtogroup bundle
 *  @{
 */

public errordomain BundlerError {
	too_big_value,
	faulty_ctn,
	ctn_full,
}

public struct shotodol.Carton {
	public aroop_uword8 data[1];
}

public enum shotodol.BundledContentType {
	NUMERIC_CONTENT = 0,
	STRING_CONTENT,
	BINARY_CONTENT,
}

public enum shotodol.BundlerAffixes {
	INFIX = 0, // memory efficient
	POSTFIX,PREFIX // time efficient
}

internal enum BundlerStates {
	READ_HEADER = 1,
}
public struct shotodol.Bundler {
	Carton*ctn;
	int entries;
	uint bytes;
	uint size;
	int affix;
	uint8 numberOfEntries;
	uint flag;
	void reset() {
		entries = 0;
		bytes = 0;
		flag = 0;
		if(affix == BundlerAffixes.PREFIX) {
			if(numberOfEntries == 0)
				numberOfEntries = 4;
			bytes = numberOfEntries << 1;
		}
	}
	public void buildFromCarton(Carton*ctn, uint size, int affix = BundlerAffixes.INFIX, uint8 givenNumberOfEntries = 0) {
		core.assert(ctn != null);
		this.ctn = ctn;
		this.size = size;
		this.affix = affix;
		numberOfEntries = givenNumberOfEntries;
		reset();
	}
	public void buildFromEXtring(extring*content, int affix = BundlerAffixes.INFIX, uint8 givenNumberOfEntries = 0) {
		genericValueHack<Carton,string> setter = genericValueHack<Carton,string>();
		setter.set(ctn,content.to_string());
		this.size = (uint)content.length();
		this.affix = affix;
		numberOfEntries = givenNumberOfEntries;
		reset();
	}
	public void close() throws BundlerError {
		if(affix == BundlerAffixes.PREFIX) {
			if((entries >= numberOfEntries)) {
				throw new BundlerError.ctn_full("No space to write more entry\n");
			}
			ctn.data[(entries<<1)] = 0;
			ctn.data[(entries<<1)+1] = numberOfEntries;
		}
		this.size = (int)bytes;
		entries = 0;
		bytes = 0;
	}
	public int writeInt(aroop_uword8 key, aroop_uword32 val) throws BundlerError {
		if(bytes+6 > size || (affix == BundlerAffixes.PREFIX && entries >= numberOfEntries)) {
			throw new BundlerError.ctn_full("No space to write int\n");
		}
		aroop_uword8 flen = (val > 0xFFFF) ? 4 : 2;
		if(affix == BundlerAffixes.PREFIX) {
			ctn.data[(entries<<1)] = (aroop_uword8)key;
			ctn.data[(entries<<1)+1] = flen;
		} else {
			ctn.data[bytes++] = (aroop_uword8)key;
			ctn.data[bytes++] = flen; // 0 means numeral , 4 is the numeral size
			flen += 2;
		}
		if(val > 0xFFFF) {
			ctn.data[bytes++] = (aroop_uword8)((val & 0xFF000000)>>24);
			ctn.data[bytes++] = (aroop_uword8)((val & 0x00FF0000)>>16);
		}
		ctn.data[bytes++] = (aroop_uword8)((val & 0x0000FF00)>>8);
		ctn.data[bytes++] = (aroop_uword8)(val & 0x000000FF);
		entries++;
		return flen;
	}
	public int writeETxt(aroop_uword8 key, extring*val) throws BundlerError {
		int headerlen = 0;
		int len = val.length();
		if(len > 100 || (len+bytes+3) > size) { // make sure that the string is sizable
			throw new BundlerError.too_big_value("Too big string to write\n");
		}
		int sentinel = 0;
		if(len == 0 || val.char_at(len-1) != '\0') {
			sentinel = 1;
		}
		aroop_uword8 desc = (1<<6) | (len+sentinel); // 1 means string
		if(affix == BundlerAffixes.PREFIX) {
			if((entries >= numberOfEntries)) {
				throw new BundlerError.ctn_full("No space to write more entry\n");
			}
			ctn.data[(entries<<1)] = (aroop_uword8)key;
			ctn.data[(entries<<1)+1] = desc;
		} else {
			ctn.data[bytes++] = (aroop_uword8)key;
			ctn.data[bytes++] = desc;
			headerlen += 2;
		}
		if(len > 0) {
			((mem)ctn.data).shift((int)bytes).copy_from((mem)val.to_string(), len);
			bytes+= len;
		}
		if(sentinel > 0) {
			ctn.data[bytes++] = '\0'; // null terminate
		}
		entries++;
		return headerlen + len + sentinel;
	}
	public int writeBin(aroop_uword8 key, mem val, int len) throws BundlerError {
		int headerlen = 0;
		if(len > 100 || (len+bytes+3) > size) { // make sure that the binary data is sizable
			throw new BundlerError.too_big_value("Too big binary data to write\n");
		}
		aroop_uword8 desc = (2<<6) | len; // 2 means binary
		if(affix == BundlerAffixes.PREFIX) {
			if((entries >= numberOfEntries)) {
				throw new BundlerError.ctn_full("No space to write more entry\n");
			}
			ctn.data[(entries<<1)] = (aroop_uword8)key;
			ctn.data[(entries<<1)+1] = desc;
		} else {
			ctn.data[bytes++] = (aroop_uword8)key;
			ctn.data[bytes++] = desc;
			headerlen += 2;
		}
		if(len > 0) {
			((mem)ctn.data).shift((int)bytes).copy_from(val, len);
			bytes+= len;
		}
		entries++;
		return headerlen + len;
	}
	public uint getCartonOccupied() {
		return bytes;
	}
	void readHeader() throws BundlerError {
		// sanity check
		if(cur_len != 0)
			throw new BundlerError.faulty_ctn("Internal error\n");
		numberOfEntries = 0;
		bytes = 0;
		while(ctn.data[(numberOfEntries << 1)] != 0) {
			if((numberOfEntries<<1) > size)
				throw new BundlerError.faulty_ctn("Faulty packet\n");
			numberOfEntries++;
		}
		numberOfEntries = ctn.data[(numberOfEntries<<1)+1] & 0x3F;
		bytes = numberOfEntries << 1;
		if(bytes > size)
			throw new BundlerError.faulty_ctn("Faulty packet\n");
		flag |= BundlerStates.READ_HEADER;
	}
	uint8 cur_key;
	int cur_type;
	int cur_len;
	public int next() throws BundlerError {
		bytes+=cur_len;
		cur_key = 0;
		aroop_uword8 desc = 0;
		if(affix == BundlerAffixes.PREFIX) {
			if((flag & BundlerStates.READ_HEADER) == 0)
				readHeader();
			cur_key = ctn.data[entries<<1];
			desc = ctn.data[(entries<<1)+1];
		} else {
			if((bytes+2) >= size) {
				return -1;
			}
			cur_key = ctn.data[bytes++];
			desc = ctn.data[bytes++];
		}
		if(cur_key == 0) return -1;
		cur_type = (desc >> 6);
		cur_len = (desc & 0x3F); // 11000000
		if((bytes+cur_len) > size) {
			throw new BundlerError.faulty_ctn("Faulty packet\n");
		}
		entries++;
		return (int)cur_key;
	}
	public int get(aroop_uword8 key) {
		int i = 0;
		uint pos = 0;
		if(affix == BundlerAffixes.PREFIX) {
			if((flag & BundlerStates.READ_HEADER) == 0)
				readHeader();
			pos = numberOfEntries<<1;
			for(i = 0; i < numberOfEntries; i++) {
				aroop_uword8 entryKey = ctn.data[i<<1];
				aroop_uword8 entryDesc = ctn.data[(i<<1)+1];
				if(entryKey == 0) return -1;
				int len = (entryDesc & 0x3F);
				if(entryKey != key) {
					pos += len;
					continue;
				}
				cur_key = entryKey;
				cur_len = len;
				bytes = pos;
				return 0;
			}
		} else {
			for(i = 0; i < size; i++) {
				aroop_uword8 entryKey = ctn.data[pos++];
				aroop_uword8 entryDesc = ctn.data[pos++];
				if(entryKey == 0) return -1;
				int len = (entryDesc & 0x3F);
				if(entryKey != key) {
					pos += len;
					continue;
				}
				cur_key = entryKey;
				cur_len = len;
				bytes = pos;
				return 0;
			}
		}
		return -1;
	}
	public uint8 getContentKey() throws BundlerError {
		return cur_key;
	}
	public int getContentType() throws BundlerError {
		return cur_type;
	}
	public unowned mem getContent() throws BundlerError {
		return ((mem)ctn.data).shift((int)bytes);
	}
	public aroop_uword32 getIntContent() throws BundlerError {
		aroop_uword32 output = 0;
		if(cur_len >= 1) {
			output = ctn.data[bytes];
		}
		if(cur_len >= 2) {
			output = output << 8;
			output |= ctn.data[bytes+1];
		}
		if(cur_len >= 3) {
			output = output << 8;
			output |= ctn.data[bytes+2];
		}
		if(cur_len == 4) {
			output = output << 8;
			output |= ctn.data[bytes+3];
		}
		return output;
	}
	public uint getContentLength() throws BundlerError {
		return cur_len;
	}
}
/** @}*/
