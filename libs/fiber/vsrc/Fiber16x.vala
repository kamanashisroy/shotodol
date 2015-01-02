using aroop;
using shotodol;

/** \addtogroup fiber
 *  @{
 */
public abstract class shotodol.Fiber16x : Fiber {
	enum Fiber16xConfig {
		MAX_FIBERS = 16,
	}
	protected Fiber?x[16]; 
	protected CompositeFiber.CompositeFiberState state;
	int count;
	
	public Fiber16x() {
#if false
		int i = 0;
		for(i=0;i<Fiber16xConfig.MAX_FIBERS;i++) {
			x[i] = null;
		}
#endif
		state = CompositeFiber.CompositeFiberState.NONE;
	}

	protected int append(Fiber?given) {
		int i = 0;
		for(i=0;i<Fiber16xConfig.MAX_FIBERS;i++) {
			if(x[i] == null) {
				x[i] = given;
				break;
			}
		}
		return 0;
	}

	protected void clearAll() {
		int i = 0;
		for(i=0;i<Fiber16xConfig.MAX_FIBERS;i++) {
			x[i] = null;
		}
	}
	
	protected override int start(Fiber?p) {
		if(state != CompositeFiber.CompositeFiberState.NONE && state != CompositeFiber.CompositeFiberState.CANCELLED) {
			core.assert(state != CompositeFiber.CompositeFiberState.NONE && state != CompositeFiber.CompositeFiberState.CANCELLED);
			return 0;
		}
		state = CompositeFiber.CompositeFiberState.STARTING;
		int i = 0;
		for(i=0;i<Fiber16xConfig.MAX_FIBERS;i++) {
			if(x[i] != null)x[i].start(this);
		}
		if(state == CompositeFiber.CompositeFiberState.CANCELLING) {
			state = CompositeFiber.CompositeFiberState.CANCELLED;
			return 0;
		}
		state = CompositeFiber.CompositeFiberState.RUNNING;
		run();
		return 0;
	}
	
	public virtual uint get_id() {
		return 0;
	}
	
	protected override int step() {
		int i = 0;
		for(i=0;i<Fiber16xConfig.MAX_FIBERS;i++) {
			if(x[i] != null && x[i].step() != 0) {
				x[i] = null;
			}
		}
		return 0;
	}
	
	protected void run() {
		while(state == CompositeFiber.CompositeFiberState.RUNNING) {
			step();
		}
		core.assert(state == CompositeFiber.CompositeFiberState.CANCELLING);
		state = CompositeFiber.CompositeFiberState.CANCELLED;
	}
	
	public override int cancel() {
		if(state == CompositeFiber.CompositeFiberState.RUNNING || state == CompositeFiber.CompositeFiberState.STARTING) {
			state = CompositeFiber.CompositeFiberState.CANCELLING;
		}
		return 0;
	}
	
	~Fiber16x() {
	}
}
/** @}*/
