#include "core/txt.h"
#include "shotodol_platform_fileutils.h"

int shotodol_opendir(shotodol_dir_t*output, struct aroop_txt*gPath) {
	if(gPath->len < gPath->size) {
		if(gPath->str[gPath->len] == '\0') {
			*output = opendir(gPath->str);
			return 0;
		}
	}
	struct aroop_txt path;
	aroop_txt_is_empty(&path);
	int len = gPath->len+1;
	aroop_txt_buffer(&path, len);
	memcpy(path->str, gPath->str, len-1);
	path->str[len-1] = '\0';
	*output = opendir(gPath->str);
	return 0;
}

int shotodol_get_iterator(shotodol_dir_t*output, shotodol_platform_iterator_t*it) {
	return 0;
}

