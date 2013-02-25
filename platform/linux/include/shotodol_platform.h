#ifndef SHOTODOL_PLUGIN_INCLUDE_H
#define SHOTODOL_PLUGIN_INCLUDE_H

#define plugin_open(x) ({ \
	void*hdl = dlopen(x,RTLD_LAZY); \
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

#endif //SHOTODOL_PLUGIN_INCLUDE_H
