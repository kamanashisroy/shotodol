#include "aroop_core.h"
#include "core/txt.h"
#include "shotodol_platform_fileutils.h"

static aroop_bool shotodol_dir_next (aroop_cl_shotodol_shotodol_default_iterator* self_data) {
	return 0;
}

static aroop_none* shotodol_dir_get (aroop_cl_shotodol_shotodol_default_iterator* self_data, void ** result) {
	shotodol_dir_t*x = (self_data+1);
	x--;
	//readdir_r(x->dir, x->entry, result);
	*result = readdir(x->dir);
	return *result;
}

static struct aroop_vtable_default_iterator dir_vtable;
static int shotodol_dir_setup(shotodol_dir_t*x) {
	if(dir_vtable.next != shotodol_dir_next)
		dir_vtable.next = shotodol_dir_next;
	if(dir_vtable.get != shotodol_dir_get)
		dir_vtable.get = shotodol_dir_get;
	x->it.vtable = &dir_vtable;
}

int shotodol_dir_open(shotodol_dir_t*x, struct aroop_txt*gPath) {
	shotodol_dir_setup(x);
	if(gPath->len < gPath->size) {
		if(gPath->str[gPath->len] == '\0') {
			x->dir = opendir(gPath->str);
			return 0;
		}
	}
	struct aroop_txt path;
	aroop_txt_is_empty(&path);
	int len = gPath->len+1;
	aroop_txt_buffer(&path, len);
	memcpy(path.str, gPath->str, len-1);
	path.str[len-1] = '\0';
	x->dir = opendir(gPath->str);
	return 0;
}


