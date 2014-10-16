using aroop;
using shotodol;

/** \addtogroup bundle
 *  @{
 */

public struct shotodol.Unbundler {
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
		cur_len = 0;
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
		this.size = (uint)content.length();
		this.affix = affix;
		numberOfEntries = givenNumberOfEntries;
		reset();
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
		cur_len = (desc & 0x3F); // 00111111
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
	public void getEXtring(extring*outparam) throws BundlerError {
		if(cur_len == 0) {
			outparam.destroy();
			return;
		}
		int len = cur_len - 1;/*ommit the null character*/
		outparam.rebuild_and_set_content((string)getContent(), len);
	}
	
}
/** @}*/
