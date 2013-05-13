using aroop;

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
	
	[CCode (cname = "int", default_value = "0", cheader_filename = "shotodol_platform.h")]
	[IntegerType (rank = 6)]
	public struct fileio {
		[CCode (cname="fileio_stdin", cheader_filename = "shotodol_platform.h")]
		public static fileio stdin();
		[CCode (cname="fileio_available_bytes", cheader_filename = "shotodol_platform.h")]
		public int available_bytes();
		[CCode (cname="fileio_read", cheader_filename = "shotodol_platform.h")]
		public int read(etxt*buf);
	}
}
