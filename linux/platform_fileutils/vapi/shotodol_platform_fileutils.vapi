using aroop;

/**
 * \ingroup platform
 * \defgroup linux_fileutils Linux net
 */

/** \addtogroup linux_fileutils
 *  @{
 */
namespace shotodol_platform_fileutils {
	[CCode (cname="shotodol_platform_iterator_t", cheader_filename = "shotodol_platform_fileutils.h")]
	public struct PIterator<G> {
		public bool next();
		public bool prev();
		public G get();
	}
	[CCode (cname="shotodol_dir_t", cheader_filename = "shotodol_platform_fileutils.h")]
	public struct Directory {
		[CCode (cname="shotodol_opendir", cheader_filename = "shotodol_platform_fileutils.h")]
		public Directory(etxt*dir); // etxt SHOULD be zero terminated
		[CCode (cname="shotodol_get_iterator", cheader_filename = "shotodol_platform_fileutils.h")]
		public getIt(PIterator<FleInfo>*it);
		[CCode (cname="shotodol_closedir", cheader_filename = "shotodol_platform_fileutils.h")]
		public int close(etxt*dir);
	}
}
/* @} */
