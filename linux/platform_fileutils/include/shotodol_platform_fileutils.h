#ifndef SHOTODOL_PLATFORM_FILE_UTILS_INCLUDE_H
#define SHOTODOL_PLATFORM_FILE_UTILS_INCLUDE_H

#include <dirent.h>
#include "core/txt.h"

typedef DIR* shotdol_dir_t;
int shotodol_opendir(shotodol_dir_t*output, struct aroop_txt*path);
int shotodol_get_iterator(shotodol_dir_t*output, shotodol_platform_iterator_t*it);

#endif //SHOTODOL_PLUGIN_INCLUDE_H
