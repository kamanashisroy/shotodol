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
	protected enum PropellerState {
		NONE,
		STARTING,
		RUNNING,
		CANCELLING,
		CANCELLED,
	}
	protected Set<Spindle> sps; 
	protected Queue<Replicable> msgs; // message queue
	protected PropellerState state;
	bool clear;
	
	public Propeller() {
		sps = Set<Spindle>(16, factory_flags.HAS_LOCK | factory_flags.SWEEP_ON_UNREF | factory_flags.EXTENDED);
		msgs = Queue<Replicable>((uchar)get_id());
		state = PropellerState.NONE;
		clear = false;
	}

	protected void clearAll() {
		sps.markAll(8);
		clear = true;
		if(state == PropellerState.CANCELLED) {
			sps.pruneMarked(8);
			sps.gc_unsafe(); // make sure they are unloaded correctly ..
			clear = false;
		}
	}
	
	protected override int start(Spindle?p) {
		if(state != PropellerState.NONE && state != PropellerState.CANCELLED) {
			core.assert(state != PropellerState.NONE && state != PropellerState.CANCELLED);
			return 0;
		}
		state = PropellerState.STARTING;
		sps.visit_each((data) => {
			unowned Spindle sp = ((AroopPointer<Spindle>)data).get();
			sp.start(this);
			return 0;
		}, Replica_flags.ALL, 0, Replica_flags.ALL, 0, 0, 0);
		if(state == PropellerState.CANCELLING) {
			state = PropellerState.CANCELLED;
			return 0;
		}
		state = PropellerState.RUNNING;
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
			sps.gc_unsafe(); // make sure they are unloaded correctly ..
			clear = false;
		}
		return 0;
	}
	
	protected void run() {
		while(state == PropellerState.RUNNING) {
			step();
		}
		core.assert(state == PropellerState.CANCELLING);
		state = PropellerState.CANCELLED;
	}
	
	public override int cancel() {
		if(state == PropellerState.RUNNING || state == PropellerState.STARTING) {
			state = PropellerState.CANCELLING;
		}
		return 0;
	}
	
	~Propeller() {
		msgs.destroy();
		sps.destroy();
	}
}
/** @}*/
