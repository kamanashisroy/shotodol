using aroop;
using shotodol;

/** \addtogroup renu
 *  @{
 */
internal class shotodol.RenuTest : UnitTest {
	public RenuTest() {
		extring tname = extring.set_static_string("RenuTest");
		base(&tname);
	}
	Renu testBuild(RenuFactory builder, int affix) {
		Renu r = builder.createRenu(128);
		Bundler bndlr = Bundler();
		bndlr.buildFromCarton(&r.msg, r.size, affix, 5);
		bndlr.writeInt(0, 0);
		bndlr.writeInt(1, 1);
		bndlr.writeInt(2, 2);
		r.finalize(&bndlr);
		return r;
	}
	void test1(RenuFactory builder, int affix) throws UnitTestError {
		Renu r = testBuild(builder, affix);
		Bundler bndlr = Bundler();
		bndlr.buildFromCarton(&r.msg, r.len, affix, 5);
		uint8 i = 0;
		while(true) {
			if(bndlr.getVal(i) == -1)
				break;
			int key = bndlr.getContentType();
			uint32 val = bndlr.getIntContent();
			if(key != 0 && val != i)
				throw new UnitTestError.FAILED("Renu serialization test failed\n");
			i++;
		}
		if(i != 3)
			throw new UnitTestError.FAILED("Renu serialization test failed\n");
	}
	void test2(RenuFactory builder, int affix) throws UnitTestError {
		Renu r = testBuild(builder, affix);
		Bundler bndlr = Bundler();
		bndlr.buildFromCarton(&r.msg, r.len, affix, 5);
		uint8 i = 0;
		while(true) {
			if(bndlr.next() == -1)
				break;
			int key = bndlr.getContentType();
			uint32 val = bndlr.getIntContent();
			if(key != 0 && val != i)
				throw new UnitTestError.FAILED("Renu serialization test failed\n");
			i++;
		}
		if(i != 3)
			throw new UnitTestError.FAILED("Renu serialization test failed\n");
	}
	public override int test() throws UnitTestError {
		RenuFactory?builder = null;
		extring entry = extring.set_static_string("renu/factory");
		Plugin.acceptVisitor(&entry, (x) => {
			builder = (RenuFactory)x.getInterface(null);
		});
		if(builder == null)
			throw new UnitTestError.FAILED("Renu factory cannot be null\n");
		test1(builder,BundlerAffixes.PREFIX);
		test1(builder,BundlerAffixes.INFIX);
		test2(builder,BundlerAffixes.PREFIX);
		test2(builder,BundlerAffixes.INFIX);
		return 0;
	}
}

/* @} */
