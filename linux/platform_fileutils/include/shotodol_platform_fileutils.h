#ifndef SHOTODOL_PLATFORM_FILE_UTILS_INCLUDE_H
#define SHOTODOL_PLATFORM_FILE_UTILS_INCLUDE_H

#include <dirent.h>
#include "core/txt.h"
#include "shotodol_iterator.h"

typedef struct {
	DIR*dir;
	//struct direct entry;
	aroop_cl_shotodol_shotodol_default_iterator it;
} shotodol_dir_t;
int shotodol_dir_open(shotodol_dir_t*output, struct aroop_txt*path);
#define shotodol_closedir(x) ({closedir((x)->dir);})

#endif //SHOTODOL_PLUGIN_INCLUDE_H
