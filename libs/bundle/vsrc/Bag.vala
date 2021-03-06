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
 * \defgroup bag Bag(Bag), is a table that contains some values. It is intended for messaging. And modules can register their attributes here and set them while messaging.
 */

/** \addtogroup bag
 *  @{
 */
public class shotodol.Bag : Replicable {
	public uint size;
	bool immutable;
	public Carton msg; // It must be the last element
	Bag(uint gSize = 32) {
		build(gSize);
	}
	public void build(uint gSize = 32) {
		size = gSize;
		immutable = false;
	}
	public void finalize(Bundler*bndlr) {
		core.assert(immutable == false);
		bndlr.close();
		size = bndlr.size;
		immutable = true;
		shrink((int)sizeof(Bag)+(int)size);
	}
	public void getContentAs(extring*content) {
		content.rebuild_and_set_content((string)msg.data, (int)size, this);
	}
}
public abstract class shotodol.BagFactory : Replicable {
	public abstract Bag createBag(uint16 sz);
}
/** @}*/
