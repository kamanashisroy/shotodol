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
	
	[CCode (cname = "int", default_value = "0", free_function = "aroop_donothing3", cheader_filename = "aroop_core.h")]
	[IntegerType (rank = 6)]
	public struct fileio {
		[CCode (cname="fileio_stdin", cheader_filename = "shotodol_platform.h")]
		public static fileio stdin();
		[CCode (cname="fileio_available_bytes", cheader_filename = "shotodol_platform.h")]
		public int available_bytes();
		[CCode (cname="fileio_read", cheader_filename = "shotodol_platform.h")]
		public int read(etxt*buf);
		[CCode (cname="fileio_read_line", cheader_filename = "shotodol_platform.h")]
		public int readLine(etxt*buf);
	}

	[Compact]
	[CCode (cname = "FILE", free_function = "fclose", cheader_filename = "stdio.h")]
	public class PlatformFileStream {
		[CCode (cname = "EOF", cheader_filename = "stdio.h")]
		public const int EOF;
		[CCode (cname = "SEEK_SET", cheader_filename = "stdio.h")]
		public const int SEEK_SET;
		[CCode (cname = "SEEK_CUR", cheader_filename = "stdio.h")]
		public const int SEEK_CUR;
		[CCode (cname = "SEEK_END", cheader_filename = "stdio.h")]
		public const int SEEK_END;

		[CCode (cname = "fopen")]
		public static PlatformFileStream? open (string path, string mode);
		[CCode (cname = "fdopen")]
		public static PlatformFileStream? fdopen (int fildes, string mode);
		[CCode (cname = "popen")]
		public static PlatformFileStream? popen (string command, string mode);

		[CCode (cname = "fprintf")]
		[PrintfFormat ()]
		public void printf (string format, ...);
		[CCode (cname = "fputc", instance_pos = -1)]
		public void putc (char c);
		[CCode (cname = "fputs", instance_pos = -1)]
		public void puts (string s);
		[CCode (cname = "fgetc")]
		public int getc ();
		[CCode (cname = "fgets", instance_pos = -1)]
		public unowned string? gets (char[] s);
		[CCode (cname = "feof")]
		public bool eof ();
		[CCode (cname = "fscanf"), ScanfFormat]
		public int scanf (string format, ...);
		[CCode (cname = "fflush")]
		public int flush ();
		[CCode (cname = "fseek")]
		public int seek (long offset, int whence);
		[CCode (cname = "ftell")]
		public long tell ();
		[CCode (cname = "rewind")]
		public void rewind ();
		[CCode (cname = "fileno")]
		public int fileno ();
		[CCode (cname = "ferror")]
		public int error ();
		[CCode (cname = "clearerr")]
		public void clearerr ();


		[CCode (cname = "linux_file_stream_fread")]
		public int read(etxt*buf);
		[CCode (cname = "linux_file_stream_fwrite")]
		public int write(etxt*buf);
		[CCode (cname = "fclose")]
		public void close ();
	}
	[CCode (cname = "linux_pthread_go_t", cheader_filename = "pthread.h", has_copy_function=false, has_destroy_function=false)]
	public delegate int PlatformThreadRun();

	[Compact]
	[CCode (cname = "pthread_t", free_function = "aroop_donothing3", cheader_filename = "shotodol_platform.h")]
	public struct PlatformThread {
		[CCode (cname = "aroop_memclean_raw2")]
		public PlatformThread();
		[CCode (cname = "linux_pthread_create_background")]
		public int start(PlatformThreadRun r);
	}

	[CCode (cname = "void", cheader_filename = "shotodol_platform.h")]
	public class ProcessControl {
		[CCode (cname = "linux_mesmerize")]
		public static void mesmerize();
	}
}
