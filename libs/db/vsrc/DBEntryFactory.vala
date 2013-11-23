using aroop;
using shotodol;

public class shotodol.DBEntryFactory : Replicable {
	// factory setup
	static Factory<DBEntry> entries;
	public static Factory<Pkt> pkts;
	public static int init() {
		entries = Factory<DBEntry>.for_type();
		pkts = Factory<Pkt>.for_type();
		return 0;
	}
	public static int deinit() {
		entries.destroy();
		pkts.destroy();
		return 0;
	}
	public static DBEntry createEntry() {
		return entries.alloc_full();
	}
}
