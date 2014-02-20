using aroop;
using shotodol;

public class shotodol.DefaultConfigEngine : ConfigEngine {
	static ConfigEngine?single;
	public DefaultConfigEngine() {
		base();
	}
	public static ConfigEngine getDefault() {
		return single;
	}
	public static void setDefault(ConfigEngine?eng) {
		single = eng;
	}
}
