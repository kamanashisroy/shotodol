using aroop;

/**
 * \ingroup platform
 * \defgroup linux_fileutils Linux net
 */

/** \addtogroup linux_fileutils
 *  @{
 */
namespace shotodol_platform_fileutils {
	[Compact]
	[CCode (cname="shotodol_platform_filenode_t", cheader_filename = "shotodol_platform_fileutils.h", free_function = "aroop_donothing", unref_function = "aroop_donothing3")]
	public class FileNode {
		[CCode (cname="filename", cheader_filename = "shotodol_platform_fileutils.h")]
		public extring fileName;
	}
	[CCode (cname="shotodol_dir_t", cheader_filename = "shotodol_platform_fileutils.h")]
	public struct Directory {
		[CCode (cname="shotodol_dir_open", cheader_filename = "shotodol_platform_fileutils.h")]
		public Directory(extring*dir); // extring SHOULD be zero terminated
		[CCode (cname="shotodol_default_iterator", cheader_filename = "shotodol_platform_fileutils.h")]
		public unowned shotodol.DefaultIterator<FileNode> iterator();
		[CCode (cname="shotodol_closedir", cheader_filename = "shotodol_platform_fileutils.h")]
		public int close();
	}
	[CCode (cname="void", cheader_filename = "shotodol_platform_fileutils.h")]
	public struct FileUtil {
		[CCode (cname="shotodol_platform_filenode_exists", cheader_filename = "shotodol_platform_fileutils.h")]
		public static bool exists(extring*filename);
		[CCode (cname="shotodol_platform_filenode_mkdir", cheader_filename = "shotodol_platform_fileutils.h")]
		public static bool mkdir(extring*filename, long mode);
	}
}
/* @} */
