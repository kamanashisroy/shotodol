using aroop;
using shotodol;

/** \addtogroup fileconfig
 *  @{
 */
public class shotodol.ConfigExtension : Extension {
	ConfigEngine?engine;
	public ConfigExtension(Module mod) {
		base(mod);
		engine = new ConfigEngine();
	}
	/*public void setConfigEngine(ConfigEngine cfg) {
		engine = cfg;
	}*/
	public override Replicable?getInterface(extring*service) {
		return engine;
	}
	public override int desc(OutputStream pad) {
		base.desc(pad);
		extring dlg = extring.stack(128);
		dlg.concat_string("\tConfig Engine\n");
		pad.write(&dlg);
		return 0;
	}
}
/** @}*/
