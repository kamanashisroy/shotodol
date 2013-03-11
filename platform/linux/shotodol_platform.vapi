

namespace shotodol_platform {
	[CCode (cname="void", cheader_filename = "dlfcn.h")]
	public class plugin {
		[CCode (cname="plugin_open", cheader_filename = "shotodol_platform.h")]
		public static unowned shotodol_platform.plugin load(string filepath);
		[CCode (cname="plugin_get_instance", cheader_filename = "shotodol_platform.h")]
		public shotodol.Module get_instance();
		[CCode (cname="plugin_close", cheader_filename = "shotodol_platform.h")]
		public int unload();
	}
}
