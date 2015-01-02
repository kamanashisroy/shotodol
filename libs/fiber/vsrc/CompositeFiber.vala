using aroop;
using shotodol;

/**
 * \defgroup library Shotodol Library modules
 */

/**
 * \ingroup library
 * \defgroup fiber A thread support system(fiber)
 * [Cohesion : Functional]
 */

/** \addtogroup fiber
 *  @{
 */
public abstract class shotodol.CompositeFiber : Fiber {
	public enum CompositeFiberState {
		NONE,
		STARTING,
		RUNNING,
		CANCELLING,
		CANCELLED,
	}
	protected Set<Fiber> sps; 
#if false
	protected Queue<Replicable> msgs; // message queue
#endif
	protected CompositeFiberState state;
	bool clear;
	
	public CompositeFiber() {
		sps = Set<Fiber>(16, factory_flags.HAS_LOCK | factory_flags.SWEEP_ON_UNREF | factory_flags.EXTENDED);
#if false
		msgs = Queue<Replicable>((uchar)get_id());
#endif
		state = CompositeFiberState.NONE;
		clear = false;
	}

	protected int append(Fiber?given) {
		sps.add(given);
		return 0;
	}

	protected void clearAll() {
		sps.markAll(8);
		clear = true;
		if(state == CompositeFiberState.CANCELLED) {
			sps.pruneMarked(8);
			sps.gc_unsafe(); // make sure they are unloaded correctly ..
			clear = false;
		}
	}
	
	protected override int start(Fiber?p) {
		if(state != CompositeFiberState.NONE && state != CompositeFiberState.CANCELLED) {
			core.assert(state != CompositeFiberState.NONE && state != CompositeFiberState.CANCELLED);
			return 0;
		}
		state = CompositeFiberState.STARTING;
		sps.visit_each((data) => {
			unowned Fiber sp = ((AroopPointer<Fiber>)data).getUnowned();
			sp.start(this);
			return 0;
		}, Replica_flags.ALL, 0, Replica_flags.ALL, 0, 0, 0);
		if(state == CompositeFiberState.CANCELLING) {
			state = CompositeFiberState.CANCELLED;
			return 0;
		}
		state = CompositeFiberState.RUNNING;
		run();
		return 0;
	}
	
	public virtual uint get_id() {
		return 0;
	}
	
	protected override int step() {
		sps.visit_each((data) => {
			unowned Fiber sp = ((AroopPointer<Fiber>)data).getUnowned();
			if(!sp.started) {
				sp.start(this);
				sp.started = true;
			}
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
		while(state == CompositeFiberState.RUNNING) {
			step();
		}
		core.assert(state == CompositeFiberState.CANCELLING);
		state = CompositeFiberState.CANCELLED;
	}
	
	public override int cancel() {
		if(state == CompositeFiberState.RUNNING || state == CompositeFiberState.STARTING) {
			state = CompositeFiberState.CANCELLING;
		}
		return 0;
	}
	
	~CompositeFiber() {
#if false
		msgs.destroy();
#endif
		sps.destroy();
	}
}
/** @}*/
