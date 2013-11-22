using aroop;
using shotodol;
using shotodol_platform;

public class shotodol.DBModule : Module {
	DBCommand db;
	public override int init() {
		db = new DBCommand();
		DBEntryFactory.init();
		//MainTurbine.gearup(db);
		return 0;
	}
	
	public override int deinit() {
		DBEntryFactory.deinit();
		return 0;
	}

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new DBModule();
	}
}

