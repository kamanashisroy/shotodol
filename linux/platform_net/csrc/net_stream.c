#include <errno.h>
#include <arpa/inet.h>
#include "aroop_core.h"
#include "core/txt.h"
#include "shotodol_platform_net.h"

int net_stream_create(struct net_stream*strm, struct aroop_txt*path, SYNC_UWORD8_T flags) {
	strm->sock = -1;
	strm->flags = 0;
	struct aroop_txt proto;
	struct aroop_txt addrstr;
	int i = 0;
	aroop_txt_is_empty(&proto);
	aroop_txt_is_empty(&addrstr);
	printf("Parsing appropriate protocol from [%s]:%d\n", path->str, path->len);
	// parse TCP://
	for(i = 0;i < path->len;i++) {
		if(path->str[i] == ':') {
			aroop_txt_embeded_same_same(&proto, path);
			proto.len = i;
			if((path->len > i+2) && (path->str[i+1] == '/') && (path->str[i+2] == '/' )) {
				aroop_txt_embeded_stackbuffer_from_txt(&addrstr, path);
				aroop_txt_shift(&addrstr, i+3);
			}
			break;
		}
	}
	printf("Parsed protocol from [%s]\n", path->str);
	if(!aroop_txt_is_empty(&proto)) {
		if(proto.len == 3 && proto.str[0] == 'T' && proto.str[1] == 'C' && proto.str[2] == 'P') {
			flags |= NET_STREAM_FLAG_TCP;
		} else if(proto.len == 3 && proto.str[0] == 'U' && proto.str[1] == 'D' && proto.str[2] == 'P') {
			flags |= NET_STREAM_FLAG_UDP;
		} else if(proto.len == 6 && proto.str[0] == 'R' && proto.str[1] == 'F' && proto.str[2] == 'C') {
			flags |= NET_STREAM_FLAG_RFCOMM;
		} else if(proto.len == 3 && proto.str[0] == 'S' && proto.str[1] == 'C' && proto.str[2] == 'O') {
			flags |= NET_STREAM_FLAG_SCO;
			flags |= NET_STREAM_FLAG_BIND;
		}
	}
	strm->flags = flags;
	if((flags & NET_STREAM_FLAG_UDP)) {
		strm->sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
	} else if((flags & NET_STREAM_FLAG_TCP)){
		strm->sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	} else if((flags & NET_STREAM_FLAG_RFCOMM)){
		strm->sock = socket(AF_BLUETOOTH, SOCK_STREAM, BTPROTO_RFCOMM);
	} else if((flags & NET_STREAM_FLAG_SCO)){
		strm->sock = socket(PF_BLUETOOTH, SOCK_SEQPACKET, BTPROTO_SCO);
	}
	printf("Opening socket at %d\n", strm->sock);
  if(strm->sock < 0) {
    //SYNC_LOG(SYNC_ERROR, "Unable to open server socket for listening:%s\n", strerror(sync_errno));
    printf("Unable to open server socket for listening:%s\n", strerror(errno));
    return -1;
  }

	printf("Opened socket %d for [%s]\n", strm->sock, path->str);
	struct aroop_txt portstr;
	aroop_txt_is_empty(&portstr);

	memset(&(strm->addr.in), 0, sizeof(strm->addr.in));
	if((flags & (NET_STREAM_FLAG_UDP|NET_STREAM_FLAG_TCP))) {
		for(i = 0;i < addrstr.len;i++) {
			if(addrstr.str[i] == ':') {
				aroop_txt_embeded_same_same(&portstr, &addrstr);
				aroop_txt_shift(&portstr, i+1);
				aroop_txt_trim_to_length(&addrstr, i);
				break;
			}
		}
		strm->addr.in.sin_family = AF_INET;
		aroop_txt_zero_terminate(&addrstr);
		inet_aton(addrstr.str, &(strm->addr.in.sin_addr));
		aroop_txt_zero_terminate(&portstr);
		strm->addr.in.sin_port = htons(aroop_txt_to_int(&portstr));
	}
	if((flags & (NET_STREAM_FLAG_RFCOMM|NET_STREAM_FLAG_SCO))) {
		strm->addr.bt.sco_family = AF_BLUETOOTH;
	  //bacpy(&strm->sbt.sco_bdaddr, &adapter->addr);
		struct aroop_txt srcaddr;
		aroop_txt_embeded_stackbuffer_from_txt(&srcaddr,&addrstr);
		aroop_txt_trim_to_length(&srcaddr,17);
		aroop_txt_zero_terminate(&srcaddr);
		str2ba(srcaddr.str, &strm->addr.bt.sco_bdaddr);
		printf("sco connect from %s\n", srcaddr.str);
	}
	if((flags & NET_STREAM_FLAG_BIND)) {
		printf("binding %s\n", addrstr.str);
		int sock_flag = 0;
		// reuse socket server to avoid bind error(Already in use)
		setsockopt(strm->sock, SOL_SOCKET, SO_REUSEADDR, (char*)&sock_flag, sizeof sock_flag);
		//SYNC_LOG(SYNC_VERB, "Binding %s\n", path->str);
		if(bind(strm->sock, (struct sockaddr*)&strm->addr, sizeof(strm->addr)) < 0) {
			//printf("Failed to bind at [%s][%s:%d]:%s\n", (flags & NET_STREAM_FLAG_TCP)?"TCP":"UDP", addrstr.str, aroop_txt_to_int(&portstr), strerror(errno));
			printf("Failed to bind at [%s]:%s\n", path->str, strerror(errno));
			net_stream_close(strm);
			return -1;
		}
#define DEFAULT_SYN_BACKLOG 1024 /* XXX we are setting this too high */
		if(!(flags & NET_STREAM_FLAG_CONNECT))if(listen(strm->sock, DEFAULT_SYN_BACKLOG) < 0) {
			//printf("Failed to listen to %s:%d:%s\n", addrstr.str, aroop_txt_to_int(&portstr), strerror(errno));
			printf("Failed to listen on [%s]:%s\n", path->str, strerror(errno));
			net_stream_close(strm);
			return -1;
		}
	}
	if((flags & NET_STREAM_FLAG_CONNECT)) {
		if((flags & (NET_STREAM_FLAG_RFCOMM|NET_STREAM_FLAG_SCO))) {
			strm->addr.bt.sco_family = AF_BLUETOOTH;
			//bacpy(&strm->sbt.sco_bdaddr, &adapter->addr);
			struct aroop_txt dstaddr;
			aroop_txt_embeded_stackbuffer_from_txt(&dstaddr,&addrstr);
			aroop_txt_shift(&dstaddr,18);
			aroop_txt_zero_terminate(&dstaddr);
			str2ba(dstaddr.str, &strm->addr.bt.sco_bdaddr);
			printf("sco connect to %s\n", dstaddr.str);
		}
		printf("Connecting to server at socket %d\n", strm->sock);
		if(connect(strm->sock, (struct sockaddr*)&strm->addr, sizeof(strm->addr)) < 0) {
			//printf("Failed to connect to [%s][%s:%d]:%s\n", (flags & NET_STREAM_FLAG_TCP)?"TCP":"UDP", addrstr.str, aroop_txt_to_int(&portstr), strerror(errno));
			printf("Failed to connect to [%s]:%s\n", path->str, strerror(errno));
			net_stream_close(strm);
			return -1;
		}
	}
	return 0;
}

int net_stream_recv(struct net_stream*strm, struct aroop_txt*buf) {
	int len = recv(strm->sock, buf->str+buf->len, buf->size - buf->len, MSG_DONTWAIT);
	if(len > 0) {
		buf->len += len;
	}
	if(len < 0) {
			printf("Error while receiving [%d]:%s\n", strm->sock, strerror(errno));
	}
	return len;
}

int net_stream_send(struct net_stream*strm, struct aroop_txt*buf) {
	int len = send(strm->sock, buf->str, buf->len, MSG_DONTWAIT);
	if(len < 0) {
			printf("Error while sending [%d]:%s\n", strm->sock, strerror(errno));
	}
	if(len > 0) {
		int left = buf->len - len;
		if(left) {
			memmove(buf->str, buf->str+len, left);
		}
		buf->len = left;
	}
	return len;
}

int net_stream_poll_check_for(struct net_stream_poll*spoll, struct net_stream*strm, int writing, int reading) {
	int i;
	for(i = 0; i < spoll->fdcount; i++) {
		if(spoll->fd_set[i].fd == strm->sock) {
			printf("reset the poll\n");
			spoll->fd_set[i].events = ((writing)?POLLOUT:0) | ((reading)?(POLLIN|POLLPRI):0) | POLLHUP;
			break;
		}
	}
	return 0;
}
int net_stream_poll_add_stream(struct net_stream_poll*spoll, struct net_stream*strm) {
	if(spoll->fdcount >= MAXIMUM_POLL_LIMIT) {
		return -1;
	}
	spoll->strms[spoll->fdcount] = strm;
	spoll->fd_set[spoll->fdcount].events = POLLIN | POLLPRI | POLLHUP;
	spoll->fd_set[spoll->fdcount].fd = strm->sock;
	spoll->fdcount++;
	spoll->evtcount = 0;
	spoll->evtindex = 0;
	return 0;
}

int net_stream_poll_delete_stream(struct net_stream_poll*spoll, struct net_stream*strm) {
	int i;
	for(i = 0; i < spoll->fdcount; i++) {
		if(spoll->fd_set[i].fd == strm->sock) {
			if(i != (spoll->fdcount-1)) {
				memcpy(spoll->fd_set+i, spoll->fd_set+i+1, (spoll->fdcount-i-1)*sizeof(spoll->fd_set[0]));
			}
			spoll->fdcount--;
			break;
		}
	}
	spoll->evtcount = 0;
	spoll->evtindex = 0;
}
enum {
#ifdef WAIT_MORE_IN_POLL
	STATE_MACHINE_POLL_TIMEOUT = 200, /* millisecond */
#else
	STATE_MACHINE_POLL_TIMEOUT = 1, /* millisecond */
#endif
};
int net_stream_poll_check_events(struct net_stream_poll*spoll) {
	spoll->evtcount = 0;
	spoll->evtindex = 0;
	if(spoll->fdcount == 0) {
		return 0;
	}
	return (spoll->evtcount = poll(spoll->fd_set, spoll->fdcount,STATE_MACHINE_POLL_TIMEOUT));
}
struct net_stream*net_stream_poll_next(struct net_stream_poll*spoll) {
	int i = 0;
	//printf("checking for revents from %d, evt count %d\n", spoll->evtindex, spoll->evtcount);
	for(i = spoll->evtindex;((spoll->evtcount) && (i < spoll->fdcount));i++) {
		if(spoll->fd_set[i].revents != 0) {
			spoll->evtindex = i;
			spoll->evtcount--;
			//printf("New event at:fd %d\n", spoll->strms[i]->sock);
			spoll->fd_set[i].revents = 0;
			return spoll->strms[i];
		}
	}
	return NULL;
}

int net_stream_accept_new(struct net_stream*newone, struct net_stream*from) {
	newone->sock = -1;
	newone->flags = 0;
	if(!(from->flags & NET_STREAM_FLAG_BIND)) {
		return -1;
	}
	socklen_t sinlen = sizeof(newone->addr.in);
	newone->sock = accept(from->sock, (struct sockaddr *)&(newone->addr.in), &sinlen);
	if(from->flags & NET_STREAM_FLAG_TCP) {
		newone->flags |= NET_STREAM_FLAG_TCP;
	}
	if(newone->sock < 0) {
		if(/*is_blocking || */errno != EAGAIN) {
			printf("Accept returned -1: %s\n", strerror(errno));
		}
	}
	printf("Accepted new connection at %d\n", newone->sock);
	return 0;
}

