using aroop;
using shotodol;

/**
 * // C code
 * struct {
 *	struct {
 *  		unsigned char key;
 *  		unsigned int type:2;
 *  		unsigned int len:6;
 * 	} array[32];
 *  	char data[4];
 * };
 *
 * */


/**
 * \ingroup bundle
 * \defgroup renu Renu(Renu), is a table that contains some values. It is intended for messaging. And modules can register their attributes here and set them while messaging.
 */

/** \addtogroup renu
 *  @{
 */
public class shotodol.Renu : Replicable {
	public uint size;
	public uint len;
	bool immutable;
	public Carton msg; // It must be the last element
	Renu(uint gSize = 32) {
		build(gSize);
	}
	public void build(uint gSize = 32) {
		size = gSize;
		len = 0;
		immutable = false;
	}
	public void finalize(Bundler*bndlr) {
		core.assert(immutable == false);
		bndlr.close();
		len = bndlr.size;
		immutable = true;
		shrink((int)len);
	}
	public void getTaskAs(extring*task) {
		task.rebuild_and_set_content((string)msg.data, (int)len, this);
	}
}
public abstract class shotodol.RenuFactory : Replicable {
	public abstract Renu createRenu(uint16 sz);
}
/** @}*/
