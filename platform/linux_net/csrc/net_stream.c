#include <socket.h>
#include "shotodol_platform_net.h"

struct net_stream*net_stream_new(struct net_stream*strm, struct aroop_txt*path, unsigned int flags) {
	strm->flags = flags;
	if((flags && NET_STREAM_FLAG_UDP)) {
		strm->sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
	} else {
		strm->sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	}
  if(strm->sock < 0) {
    SYNC_LOG(SYNC_ERROR, "Unable to open server socket for listening:%s\n", strerror(sync_errno));
    return NULL;
  }

	if((flags && NET_STREAM_FLAG_BIND)) {
		int sock_flag = 0;
		// reuse socket server to avoid bind error(Already in use)
		setsockopt(strm->sock, SOL_SOCKET, SO_REUSEADDR, (char*)&sock_flag, sizeof sock_flag);
		inet_aton(path->str, &strm->sin.sin_addr);
		//SYNC_LOG(SYNC_VERB, "Binding %s\n", path->str);
		if(bind(strm->sock, &strm->sin, sizeof(strm->sin)) < 0) {
			//SYNC_LOG(SYNC_ERROR, "Failed to bind to %s:%d:%s\n", SYNC_SOCKADDR_STRINGIFY2(*bindaddr), SYNC_SOCKADDR_GET_PORT(*bindaddr), strerror(sync_errno));
			SYNC_LOG(SYNC_ERROR, "Failed to bind:%s\n", strerror(sync_errno));
			shutdown(strm->sock, SHUT_RDWR);
			return NULL;
		}
	}
}

