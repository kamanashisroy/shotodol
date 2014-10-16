using aroop;
using shotodol;

/** \addtogroup bag
 *  @{
 */
internal class shotodol.BagTest : UnitTest {
	public BagTest() {
		extring tname = extring.set_static_string("BagTest");
		base(&tname);
	}
	Bag testBuild(BagFactory builder, int affix) {
		Bag r = builder.createBag(128);
		Bundler bndlr = Bundler();
		bndlr.buildFromCarton(&r.msg, r.size, affix, 5);
		bndlr.writeInt(1, 1);
		bndlr.writeInt(2, 2);
		bndlr.writeInt(3, 3);
		r.finalize(&bndlr);
		return r;
	}
	void test1(BagFactory builder, int affix) throws UnitTestError {
		Bag r = testBuild(builder, affix);
		Unbundler ubndlr = Unbundler();
		ubndlr.buildFromCarton(&r.msg, r.size, affix, 5);
		uint8 i = 1;
		while(true) {
			if(ubndlr.get(i) == -1)
				break;
			int ct = ubndlr.getContentType();
			uint32 val = ubndlr.getIntContent();
			if(ct != 0 && val != i) {
				throw new UnitTestError.FAILED("Bag serialization test failed\n");
			}
			i++;
		}
		if(i != 4)
			throw new UnitTestError.FAILED("Bag serialization test failed\n");
	}
	void test2(BagFactory builder, int affix) throws UnitTestError {
		Bag r = testBuild(builder, affix);
		Unbundler ubndlr = Unbundler();
		ubndlr.buildFromCarton(&r.msg, r.size, affix, 5);
		uint8 i = 1;
		while(true) {
			if(ubndlr.next() == -1)
				break;
			uint8 key = ubndlr.getContentKey();
			int ct = ubndlr.getContentType();
			uint32 val = ubndlr.getIntContent();
			if(ct != 0 && val != key) {
				throw new UnitTestError.FAILED("Bag serialization test failed\n");
			}
			i++;
		}
		if(i != 4) {
			throw new UnitTestError.FAILED("Bag serialization test failed\n");
		}
	}
	public override int test() throws UnitTestError {
		BagFactory?builder = null;
		extring entry = extring.set_static_string("bag/factory");
		Plugin.acceptVisitor(&entry, (x) => {
			builder = (BagFactory)x.getInterface(null);
		});
		if(builder == null)
			throw new UnitTestError.FAILED("Bag factory cannot be null\n");
		test1(builder,BundlerAffixes.PREFIX);
		test1(builder,BundlerAffixes.INFIX);
		test2(builder,BundlerAffixes.PREFIX);
		test2(builder,BundlerAffixes.INFIX);
		return 0;
	}
}

/* @} */
