#include "aroop/aroop_core.h"
#include "aroop/core/xtring.h"
#include "shotodol_platform_fileutils.h"

static aroop_bool shotodol_dir_next (aroop_cl_shotodol_default_iterator* self_data) {
	return 0;
}

static aroop_none* shotodol_dir_get (aroop_cl_shotodol_default_iterator* self_data, void ** result) {
	shotodol_dir_t*x = (self_data+1);
	x--;
	//readdir_r(x->dir, x->entry, result);
	struct dirent*node = readdir(x->dir);
	if(node == NULL) {
		*result = NULL;
		return *result;
	}
	aroop_txt_embeded_rebuild_and_set_content(&x->filenode.filename,node->d_name,strlen(node->d_name),NULL);
	*result = &x->filenode;
	return *result;
}

static struct aroop_vtable_default_iterator dir_vtable;
static int shotodol_dir_setup(shotodol_dir_t*x) {
	if(dir_vtable.next != shotodol_dir_next)
		dir_vtable.next = shotodol_dir_next;
	if(dir_vtable.get != shotodol_dir_get)
		dir_vtable.get = shotodol_dir_get;
	x->it.vtable = &dir_vtable;
	aroop_memclean_raw(&x->filenode.filename, sizeof(x->filenode.filename));
}

int shotodol_dir_open(shotodol_dir_t*x, struct aroop_txt*gPath) {
	shotodol_dir_setup(x);
	char*pathstr = aroop_txt_to_string(gPath);
	if(aroop_txt_zero_terminate(gPath)) {
		x->dir = opendir(pathstr);
		return 0;
	}
	struct aroop_txt path;
	aroop_memclean_raw(&path, sizeof(path));
	int len = gPath->len+1;
	aroop_txt_embeded_stackbuffer(&path, len);
	char*newpathstr = aroop_txt_to_string(&path);
	memcpy(newpathstr, pathstr, len-1);
	newpathstr[len-1] = '\0';
	x->dir = opendir(newpathstr);
	aroop_txt_destroy(&path);
	return 0;
}


