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
	[CCode (cname="shotodol_platform_filenode_t", cheader_filename = "shotodol_platform_fileutils.h")]
	public class FileNode {
		[CCode (cname="filename", cheader_filename = "shotodol_platform_fileutils.h")]
		public etxt fileName;
	}
	[CCode (cname="shotodol_dir_t", cheader_filename = "shotodol_platform_fileutils.h")]
	public struct Directory {
		[CCode (cname="shotodol_opendir", cheader_filename = "shotodol_platform_fileutils.h")]
		public Directory(etxt*dir); // etxt SHOULD be zero terminated
		[CCode (cname="&it", cheader_filename = "shotodol_platform_fileutils.h")]
		public unowned DefaultIterator<FileNode> it;
		[CCode (cname="shotodol_closedir", cheader_filename = "shotodol_platform_fileutils.h")]
		public int close();
	}
}
/* @} */
