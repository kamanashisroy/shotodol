#ifndef SHOTODOL_PLATFORM_INCLUDE_H
#define SHOTODOL_PLATFORM_INCLUDE_H

// public class dynalib

//#define DYNALIB_ROOT "/media/active/projects/shotodol/"
#ifndef DYNALIB_ROOT
#error "Please set DYNALIB_ROOT in cflags"
#endif

#define dynalib_open(x) ({ \
	void*hdl = dlopen(x,RTLD_LAZY | RTLD_GLOBAL); \
	char*derror = NULL; \
	if ((derror = dlerror()) != NULL)  { \
	   fprintf(stderr, "%s\n", derror); \
	} \
	hdl; \
})
#define dynalib_close(x) ({dlclose(x);})
#define dynalib_get_instance(x) ({ \
	void*(*init_cb)(); \
	*(void **) (&init_cb) = dlsym(x, "get_module_instance"); \
	char*derror = NULL; \
	if ((derror = dlerror()) != NULL)  { \
	   fprintf(stderr, "%s\n", derror); \
	} \
	void*val = NULL; \
	if(init_cb != NULL) { \
		val = init_cb(); \
	} \
	val;\
})

// public class fileio

#include <unistd.h>
#include <fcntl.h>
#define fileio_stdin() ({int _stdfd = dup(STDIN_FILENO);long flags = fcntl(_stdfd, F_GETFL);fcntl(_stdfd, F_SETFL, flags|O_NONBLOCK);_stdfd;})
#define platform_file_stream_unref(tdata,index,x) ({if(x)fclose(x);0;})

#if 1
#include <sys/ioctl.h> // defines FIONREAD 
#define fileio_available_bytes(x) ({ \
	int __bt=0;ioctl(x, FIONREAD, &__bt);__bt; \
})
#else
#include <poll.h>
#define fileio_available_bytes(x) ({ \
	struct pollfd fds; \
  int ret; \
  fds.fd = fileno(stdin); \
  fds.events = POLLIN; \
  poll(&fds, 1, 0); \
})
#endif

#if 1
#define fileio_read(x,y) ({ \
	int __rt = read(x, aroop_txt_to_string(y)+(y)->len, (y)->size - (y)->len - 1);if(__rt > 0) {(y)->len += __rt;}__rt; \
})
#else
#define fileio_read(x,y) ({ \
	char*__rt = fgets((y)->str+(y)->len, (y)->size - (y)->len, stdin);if(__rt != NULL) {(y)->len += strlen(__rt);}strlen(__rt); \
})
#endif

#define fileio_read_line(x,y) ({ \
	int __len = 0;char* __rt = fgets(aroop_txt_to_string(y)+(y)->len, (y)->size - (y)->len - 1, stdin);if(__rt) {__len = strlen(__rt);(y)->len += __len;}__len; \
})

#define fileio_getc(x) ({getc(stdin);})
#define fileio_ungetc(x,y) ({ungetc(y,stdin);})

//public class PlatformFileStream
#define linux_file_stream_fread(x,y) ({ \
	int __rt = fread(aroop_txt_to_string(y)+(y)->len, 1, (y)->size - (y)->len - 1, x);if(__rt > 0) {(y)->len += __rt;}__rt; \
})
#define linux_file_stream_fwrite(x,y) ({ \
	fwrite(aroop_txt_to_string(y), 1, (y)->len, x);\
})

typedef int (*linux_pthread_go_cb_t)(void*data);
typedef struct {
	void*aroop_closure_data;
	linux_pthread_go_cb_t aroop_cb;
} linux_pthread_go_t;
// PlatformThread
#define linux_pthread_create_background(x, cb) ({ \
	int __ecode; \
	pthread_attr_t __ptattr; \
	__ecode = pthread_attr_init(&__ptattr); \
	if(!__ecode){ \
		__ecode = pthread_attr_setdetachstate(&__ptattr, PTHREAD_CREATE_DETACHED); \
		if(!__ecode)__ecode = pthread_create(x, &__ptattr, cb.aroop_cb, cb.aroop_closure_data); \
		pthread_attr_destroy(&__ptattr); \
	}\
__ecode;})

#define linux_mesmerize() ({usleep(200);})
#define linux_millisleep(x) ({usleep(x*1000);})

#endif //SHOTODOL_PLUGIN_INCLUDE_H
