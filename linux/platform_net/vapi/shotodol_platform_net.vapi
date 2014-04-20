using aroop;

/**
 * \ingroup platform
 * \defgroup linux_net Linux net
 */

/** \addtogroup linux_net
 *  @{
 */
namespace shotodol_platform_net {
	[CCode (lower_case_cprefix = "NET_STREAM_FLAG_")]
	enum ConnectFlags {
		BIND = 1,
		UDP = 1<<1,
		TCP = 1<<2,
		CONNECT = 1<<3,
	}
	[CCode (cname="struct net_stream", cheader_filename = "shotodol_platform_net.h")]
	public struct NetStreamPlatformImpl {
		[CCode (cname="net_stream_empty", cheader_filename = "shotodol_platform_net.h")]
		public NetStreamPlatformImpl();
		[CCode (cname="net_stream_create", cheader_filename = "shotodol_platform_net.h")]
		public int connect(etxt*path, aroop_uword8 flags);
		[CCode (cname="net_stream_accept_new", cheader_filename = "shotodol_platform_net.h")]
		public int accept(NetStreamPlatformImpl*server);
		[CCode (cname="net_stream_recv", cheader_filename = "shotodol_platform_net.h")]
		public int read(etxt*buf);
		[CCode (cname="net_stream_send", cheader_filename = "shotodol_platform_net.h")]
		public int write(etxt*buf);
		[CCode (cname="net_stream_close", cheader_filename = "shotodol_platform_net.h")]
		public int close();
	}
	[CCode (cname="struct net_stream_poll", cheader_filename = "shotodol_platform_net.h")]
	public struct NetStreamPollPlatformImpl {
		[CCode (cname="net_stream_poll_create", cheader_filename = "shotodol_platform_net.h")]
		public NetStreamPollPlatformImpl();
		[CCode (cname="net_stream_poll_add_stream", cheader_filename = "shotodol_platform_net.h")]
		public int add(NetStreamPlatformImpl*strm);
		[CCode (cname="net_stream_poll_check_for", cheader_filename = "shotodol_platform_net.h")]
		public int check_for(NetStreamPlatformImpl*strm, bool writing, bool reading);
		[CCode (cname="net_stream_poll_delete_stream", cheader_filename = "shotodol_platform_net.h")]
		public int remove(NetStreamPlatformImpl*strm);
		[CCode (cname="net_stream_poll_check_events", cheader_filename = "shotodol_platform_net.h")]
		public int check_events();
		[CCode (cname="net_stream_poll_next", cheader_filename = "shotodol_platform_net.h")]
		public NetStreamPlatformImpl*next();
	}
}
/* @} */
