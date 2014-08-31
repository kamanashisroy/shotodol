using aroop;
using shotodol;

/** \addtogroup config
 *  @{
 */
public class shotodol.DefaultConfigEngine : ConfigEngine {
	static ConfigEngine?single;
	public DefaultConfigEngine() {
		base();
	}
	~DefaultConfigEngine() {
		single = null;
	}
	public static ConfigEngine getDefault() {
		return single;
	}
	public static void setDefault(ConfigEngine?eng) {
		single = eng;
	}
}
/** @}*/
