using aroop;
using shotodol;

internal class ConfigEntry : Replicable {
	internal etxt name;
	HashTable<txt> tbl;

	~ConfigEntry() {
		tbl.destroy();
	}

	internal void build(etxt*myName) {
		name = etxt.same_same(myName);
		tbl = HashTable<txt>();
	}

	internal int set(txt myKey, txt myValue) {
		return tbl.set(myKey, myValue);
	}
}
