using aroop;

namespace shotodol_platform_net {
	[CCode (lower_case_cprefix = "NET_STREAM_FLAG_")]
	enum NetStreamFlags {
		BIND = 1,
		UDP = 1<<1,
		TCP = 1<<2,
	}
	[CCode (cname="struct net_stream*", cheader_filename = "shotodol_platform_net.h")]
	public struct NetStream {
		[CCode (cname="net_stream_new", cheader_filename = "shotodol_platform_net.h")]
		public NetStream(etxt*path, aroop_uword8 flags);
		[CCode (cname="net_stream_close", cheader_filename = "shotodol_platform_net.h")]
		public int close();
	}
}
