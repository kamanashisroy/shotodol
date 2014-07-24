#ifndef SHOTODOL_PLATFORM_FILE_UTILS_INCLUDE_H
#define SHOTODOL_PLATFORM_FILE_UTILS_INCLUDE_H

#include <dirent.h>
#include "aroop/core/txt.h"
#include "shotodol_iterator.h"

typedef struct {
	aroop_txt_t filename;
} shotodol_platform_filenode_t;

typedef struct {
	DIR*dir;
	//struct direct entry;
	shotodol_platform_filenode_t filenode;
	aroop_cl_shotodol_shotodol_default_iterator it;
} shotodol_dir_t;
int shotodol_dir_open(shotodol_dir_t*output, struct aroop_txt*path);
#define shotodol_default_iterator(x) (&((x)->it))
#define shotodol_closedir(x) ({closedir((x)->dir);})

#endif //SHOTODOL_PLUGIN_INCLUDE_H
