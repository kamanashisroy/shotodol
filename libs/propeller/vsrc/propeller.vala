using aroop;
using shotodol;

/**
 * \defgroup library Shotodol Library modules
 */

/**
 * \ingroup library
 * \defgroup propeller A thread support system(propeller)
 * [Cohesion : Functional]
 */

/** \addtogroup propeller
 *  @{
 */
public abstract class shotodol.Propeller : Spindle {
	protected Set<Spindle> sps; 
	protected Queue<Replicable> msgs; // message queue
	protected bool cancelled;
	bool clear;
	
	public Propeller() {
		sps = Set<Spindle>(16, factory_flags.HAS_LOCK | factory_flags.SWEEP_ON_UNREF | factory_flags.EXTENDED);
		msgs = Queue<Replicable>((uchar)get_id());
		clear = false;
	}

	protected void clearAll() {
		sps.markAll(8);
		clear = true;
	}
	
	protected override int start(Spindle?p) {
		cancelled = false;
		sps.visit_each((data) => {
			unowned Spindle sp = ((AroopPointer<Spindle>)data).get();
			sp.start(this);
			return 0;
		}, Replica_flags.ALL, 0, Replica_flags.ALL, 0, 0, 0);
		run();
		return 0;
	}
	
	public virtual uint get_id() {
		return 0;
	}
	
	protected override int step() {
		sps.visit_each((data) => {
			unowned Spindle sp = ((AroopPointer<Spindle>)data).get();
			if(sp.step() != 0) {
				data.unpin(); // delete this process from list
			}
			return 0;
		}, Replica_flags.ALL, 0, Replica_flags.ALL, 0, 0, 0);
		if(clear) {
			sps.pruneMarked(8);
			clear = false;
		}
		return 0;
	}
	
	protected void run() {
		while(!cancelled) {
			step();
		}
	}
	
	public override int cancel() {
		cancelled = true;
		return 0;
	}
	
	~Propeller() {
		msgs.destroy();
		sps.destroy();
	}
}
/** @}*/
