#ifndef SHOTODOL_PLUGIN_INCLUDE_H
#define SHOTODOL_PLUGIN_INCLUDE_H

// public class plugin

#define plugin_open(x) ({ \
	void*hdl = dlopen(x,RTLD_LAZY | RTLD_GLOBAL); \
	char*derror = NULL; \
	if ((derror = dlerror()) != NULL)  { \
	   fprintf(stderr, "%s\n", derror); \
	} \
	hdl; \
})
#define plugin_close(x) ({dlclose(x);})
#define plugin_get_instance(x) ({ \
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

//#include <sys/filio.h> // defines FIONREAD 
#define fileio_stdin() ({STDIN_FILENO;})

#define fileio_available_bytes(x) ({ \
	int __bt=0;/*ioctl(x, FIONREAD, &__bt);*/__bt; \
})

#define fileio_read(x,y) ({ \
	int __rt = read(x, (y)->str+(y)->len, (y)->size - (y)->len - 1);if(__rt > 0) {(y)->len += __rt;}__rt; \
})

#define fileio_read_line(x,y) ({ \
	int __len = 0;char* __rt = fgets((y)->str+(y)->len, (y)->size - (y)->len - 1, stdin);if(__rt) {__len = strlen(__rt);(y)->len += __len;}__len; \
})

//public class LinuxFileStream
#define linux_file_stream_fread(x,y) ({ \
	int __rt = fread((y)->str+(y)->len, 1, (y)->size - (y)->len - 1, x);if(__rt > 0) {(y)->len += __rt;}__rt; \
})


#endif //SHOTODOL_PLUGIN_INCLUDE_H
