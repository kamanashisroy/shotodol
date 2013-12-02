#ifndef SHOTODOL_PLUGIN_INCLUDE_H
#define SHOTODOL_PLUGIN_INCLUDE_H

enum {
	NET_STREAM_FLAG_BIND = 1,
	NET_STREAM_FLAG_UDP = 1<<1,
	NET_STREAM_FLAG_TCP = 1<<2,
};
struct net_stream {
	int sock;
	struct sockaddr_in sin;
	SYNC_UWORD8 flags;
};

struct net_stream*net_stream_new(struct net_stream*strm, struct aroop_txt*path, unsigned int flags);

#endif //SHOTODOL_PLUGIN_INCLUDE_H
