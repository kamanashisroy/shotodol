using aroop;

namespace shotodol_platform_net {
	[CCode (lower_case_cprefix = "NET_STREAM_FLAG_")]
	enum ConnectFlags {
		BIND = 1,
		UDP = 1<<1,
		TCP = 1<<2,
	}
	[CCode (cname="struct net_stream", cheader_filename = "shotodol_platform_net.h")]
	public struct NetStreamPlatformImpl {
		[CCode (cname="net_stream_empty", cheader_filename = "shotodol_platform_net.h")]
		public NetStreamPlatformImpl();
		[CCode (cname="net_stream_create", cheader_filename = "shotodol_platform_net.h")]
		public int connect(etxt*path, aroop_uword8 flags);
		[CCode (cname="net_stream_recv", cheader_filename = "shotodol_platform_net.h")]
		public int read(etxt*buf);
		[CCode (cname="net_stream_send", cheader_filename = "shotodol_platform_net.h")]
		public int write(etxt*buf);
		[CCode (cname="net_stream_close", cheader_filename = "shotodol_platform_net.h")]
		public int close();
	}
}
