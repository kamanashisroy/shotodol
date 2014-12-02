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
	unexpected_header,
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
	uint bagTag;
	uint bytes;
	uint size;
	int affix;
	uint8 numberOfEntries;
	void reset() {
		entries = 0;
		bytes = 0;
		if(affix == BundlerAffixes.PREFIX) {
			if(numberOfEntries == 0)
				numberOfEntries = 4;
			bytes = numberOfEntries << 1;
		}
		//cur_len = 0;
	}
	public void buildFromCarton(Carton*ctn, uint size, int affix = BundlerAffixes.INFIX, uint8 givenNumberOfEntries = 0) {
		core.assert(ctn != null);
		this.ctn = ctn;
		this.size = size;
		this.affix = affix;
		numberOfEntries = givenNumberOfEntries;
		reset();
	}
	public void build(extring*content, int affix = BundlerAffixes.INFIX, uint8 givenNumberOfEntries = 0) {
		genericValueHack<Carton,string> setter = genericValueHack<Carton,string>();
		setter.set(ctn,content.to_memory());
		this.size = (uint)content.size();
		this.affix = affix;
		numberOfEntries = givenNumberOfEntries;
		reset();
	}
	/**
	 * Bag tags are header memory kept unused for tagging.
	 */
	public void setBagTagLength(uint givenBagTagLength) throws BundlerError {
		if(bytes != 0)
			throw new BundlerError.unexpected_header("Cannot add header now\n");
		if(givenBagTagLength >= size)
			throw new BundlerError.ctn_full("No space to add header\n");

		bagTag = givenBagTagLength;
		bytes += bagTag;
	}
	public void close() throws BundlerError {
		if(affix == BundlerAffixes.PREFIX) {
			if((entries >= numberOfEntries)) {
				throw new BundlerError.ctn_full("No space to write more entry\n");
			}
			ctn.data[bagTag+(entries<<1)] = 0;
			ctn.data[bagTag+(entries<<1)+1] = numberOfEntries;
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
			ctn.data[bagTag+(entries<<1)] = (aroop_uword8)key;
			ctn.data[bagTag+(entries<<1)+1] = flen;
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
	
	public int writeEXtring(aroop_uword8 key, extring*val) throws BundlerError {
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
			ctn.data[headerlen+(entries<<1)] = (aroop_uword8)key;
			ctn.data[headerlen+(entries<<1)+1] = desc;
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
	public int writeBin(aroop_uword8 key, mem val, uint len) throws BundlerError {
		int headerlen = 0;
		if(len > 100 || (len+bytes+3) > size) { // make sure that the binary data is sizable
			throw new BundlerError.too_big_value("Too big binary data to write\n");
		}
		aroop_uword8 desc = (2<<6) | len; // 2 means binary
		if(affix == BundlerAffixes.PREFIX) {
			if((entries >= numberOfEntries)) {
				throw new BundlerError.ctn_full("No space to write more entry\n");
			}
			ctn.data[headerlen+(entries<<1)] = (aroop_uword8)key;
			ctn.data[headerlen+(entries<<1)+1] = desc;
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
		return headerlen + (int)len;
	}
	public uint getCartonOccupied() {
		return bytes;
	}
}

/** @}*/
