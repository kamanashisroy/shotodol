using aroop;
using shotodol;

/** \addtogroup db 
 *  @{
 */

class shotodol.DBEntryCell : Replicable {
	public aroop_hash hash;
	public Carton content;
	public class DBEntryCell() {
		hash = 0;
	}
}

public struct DBId {
	aroop_hash hash;
}

public errordomain db_entry.entry_error {
	entry_closed,
}

public class shotodol.DBEntryFactory : Replicable {
	// factory setup
	static Factory<DBEntry> entries;
	internal static Factory<DBEntryCell> cells;
	public static int init() {
		entries = Factory<DBEntry>.for_type();
		cells = Factory<DBEntryCell>.for_type();
		return 0;
	}
	public static int deinit() {
		entries.destroy();
		cells.destroy();
		return 0;
	}
	public static DBEntry createEntry() {
		return entries.alloc_full();
	}
}

public class shotodol.DBEntry : Searchable {
	Bundler bndlr;
	bool closed;
	public DBEntry(DBId id) {
		DBEntryCell cell = DBEntryFactory.cells.alloc_full(); // XXX how to free the memory ??
		bndlr.buildFromCarton(&cell.content, 32);
		cell.hash = id.hash;
		closed = false;
	}

	public int build(DBId id) {
		DBEntryCell cell = DBEntryFactory.cells.alloc_full(); // XXX how to free the memory ??
		bndlr.buildFromCarton(&cell.content, 32);
		cell.hash = id.hash;
		closed = false;
		return 0;
	}
	
	public int addInt(int index, int val) throws BundlerError {
		if(closed) {
			throw new db_entry.entry_error.entry_closed("entry closed\n");
		}
		bndlr.writeInt((aroop_uword8)index, val);
		return 0;
	}
	
	public int addTxt(int index, str val) throws BundlerError {
		if(closed) {
			throw new db_entry.entry_error.entry_closed("entry closed\n");
		}
		bndlr.writeETxt((aroop_uword8)index, val);
		return 0;
	}

	public int addETxt(int index, estr*val) throws BundlerError {
		if(closed) {
			throw new db_entry.entry_error.entry_closed("entry closed\n");
		}
		bndlr.writeETxt((aroop_uword8)index, val);
		return 0;
	}

	public int copyAs(estr*output) {
		output.rebuild_and_set_content((string)bndlr.ctn.data, bndlr.bytes,this);
		return 0;
	}
	
	public int close() {
		closed = true;
		return 0;
	}
}
/** @}*/
