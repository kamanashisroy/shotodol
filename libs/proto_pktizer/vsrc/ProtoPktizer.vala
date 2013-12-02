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


public errordomain proto_pktizer.pktizer_error {
	too_big_value,
	faulty_pkt,
	pkt_full,
}

public class shotodol.Pkt : Replicable {
	public aroop_hash hash;
	public aroop_uword8 data[16];
	public class Pkt() {
		hash = 0;
	}
}

public struct shotodol.ProtoPktizer {
	Pkt pkt;
	int entries;
	int bytes;
	int size;
	public void setPkt(Pkt pkt, int size) {
		this.pkt = pkt;
		entries = 0;
		bytes = 0;
		this.size = size;
	}
	public void close() {
		this.size = bytes;
		entries = 0;
		bytes = 0;
	}
	public int writeInt(aroop_uword8 key, int val) throws proto_pktizer.pktizer_error {
		// TODO check Pkt.size
		if(bytes+6 > size) {
			throw new proto_pktizer.pktizer_error.pkt_full("No space to write int\n");
		}
		
		pkt.data[bytes++] = (aroop_uword8)key;
		if(val >= 0xFFFF) {
			pkt.data[bytes++] = /*(0<<6) |*/ 4; // 0 means numeral , 4 is the numeral size
			pkt.data[bytes++] = (aroop_uword8)((val & 0xFF000000)>>24);
			pkt.data[bytes++] = (aroop_uword8)((val & 0x00FF0000)>>16);
			pkt.data[bytes++] = (aroop_uword8)((val & 0x0000FF00)>>8);
			pkt.data[bytes++] = (aroop_uword8)(val & 0x000000FF);
			entries++;
			return 6;
		} else {
			pkt.data[bytes++] = /*(0<<6) |*/ 2; // 0 means numeral , 2 is the numeral size
			pkt.data[bytes++] = (aroop_uword8)((val & 0xFF00)>>8);
			pkt.data[bytes++] = (aroop_uword8)(val & 0x00FF);
			entries++;
			return 4;
		}
	}
	public int writeETxt(aroop_uword8 key, etxt*val) throws proto_pktizer.pktizer_error {
		// TODO check Pkt.size
		int len = val.length();
		if(len > 100) { // make sure that the string is sizable
			throw new proto_pktizer.pktizer_error.too_big_value("Too big string to write\n");
		}
		pkt.data[bytes++] = (aroop_uword8)key;
		pkt.data[bytes++] = (1<<6) | (len+1); // 1 means string
		if(len > 0) {
			((mem)pkt.data).shift(bytes).copy_from((mem)val.to_string(), len);
			bytes+= len;
		}
		pkt.data[bytes++] = '\0'; // null terminate
		return len+1+2;
	}
	public int writeBin(aroop_uword8 key, mem val, int len) throws proto_pktizer.pktizer_error {
		// TODO check Pkt.size
		if(len > 100) { // make sure that the string is sizable
			throw new proto_pktizer.pktizer_error.too_big_value("Too big binary data to write\n");
		}
		pkt.data[bytes++] = (aroop_uword8)key;
		pkt.data[bytes++] = (2<<6) | len; // 2 means numeric
		if(len > 0) {
			((mem)pkt.data).shift(bytes).copy_from(val, len);
			bytes+= len;
		}
		return len+2;
	}
	public int next() throws proto_pktizer.pktizer_error {
		if((bytes+2) >= size) {
			return -1;
		}
		int key = pkt.data[bytes++];
		int type = (pkt.data[bytes] >> 6);
		int len = (pkt.data[bytes++] & 0x3F); // 11000000
		if((bytes+len) > size) {
			throw new proto_pktizer.pktizer_error.faulty_pkt("Faulty packet\n");
		}
		return key;
	}
}
