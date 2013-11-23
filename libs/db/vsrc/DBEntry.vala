using aroop;
using shotodol;

public struct DBId {
	aroop_hash hash;
}

public errordomain db_entry.entry_error {
	entry_closed,
}

public class shotodol.DBEntry : Searchable {
	ProtoPktizer pktizer;
	bool closed;
	public DBEntry(DBId id) {
		Pkt pkt = DBEntryFactory.pkts.alloc_full(); // XXX how to free the memory ??
		pktizer.setPkt(pkt, 32);
		pkt.hash = id.hash;
		closed = false;
	}
	
	public int addInt(int index, int val) throws proto_pktizer.pktizer_error {
		if(closed) {
			throw new db_entry.entry_error.entry_closed("entry closed\n");
		}
		pktizer.writeInt((aroop_uword8)index, val);
		return 0;
	}
	
	public int addTxt(int index, txt val) throws proto_pktizer.pktizer_error {
		if(closed) {
			throw new db_entry.entry_error.entry_closed("entry closed\n");
		}
		// TODO fill me
		//pkt.writeETxt();
		return 0;
	}
	
	public int close() {
		closed = true;
		return 0;
	}
}
