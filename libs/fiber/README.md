CompositeFiber
==========

Concurrency is achieved in shotodol using _SpinningWheel_, _CompositeFiber_ and _Fiber_. It has both preemptive and non-preemptive multitasking. 

[CompositeFiber](vsrc/propeller.vala) is a thread. It is collection of spindles. And it executes the _step()_ method of registered [Fibers](vsrc/spindle.vala) one by one. If _step()_ returns nonzero then it is oust from the execution line. 

[SpinningWheel](../turbine/vsrc/SpinningWheel.vala) is a _CompositeFiber_ that integrates the platform thread library. An application may contain only main thread which can perform _CompositeFiber_ without the need of _SpinningWheel_ . Otherwise if it contains multiple threads, it will need _SpinningWheel_ to create them. 

### Call flow

_CompositeFiber_ has following important methods as listed here. 

- start()
- stop()
- step()
- run()
- cancel()

These methods relate to _Fiber_ methods as listed here.

- start()
- step()
- cancel()

Again the _SpinningWheel_ has some important methods as listed below.

- startup()

The relation to these methods and the call-flow is shown below.

| Component | Called methods |
|:--------------- |:-------|
|SpinningWheel.startup() | CompositeFiber.start() |
|CompositeFiber.start() | Fiber.start(),CompositeFiber.run() |
|CompositeFiber.run() | CompositeFiber.step() |
|CompositeFiber.step() | Fiber.step() |

In the table above it is clear, that _CompositeFiber_ can be started from _main()_ calling just _start()_ method. And when it returns the thread exits.

### Atomicity

The step() method in a _Fiber_ is executed one by one by _CompositeFiber_. So it is atomic in respect to the _CompositeFiber_. The table below lists who is atomic in respect to what.

| Component | Atomicity | In relation to |
|:----------------|:-------------|:------------------|
|_Fiber.step()_|atomic|Owner _CompositeFiber_ and other _spindles_ inside it.|
|_Fiber.step()_|non-atomic|Multi-threaded application|
|_CompositeFiber.run()_|atomic|_SpinningWheel_|
|_CompositeFiber.run()_|non-atomic|Multi-threaded application |

### Preemption

Shotodol incorporates both preemptive and non-preemptive way to execute instructions. The _CompositeFiber_ and _Fiber_ are both non-preemptive, while the _SpinningWheel_ execution is preemptive. 

| Component | Preemptive |
|:----------------|:---------------|
| CompositeFiber.run() | false |
| CompositeFiber.step() | false |
| Fiber.step() | false |
| SpinningWheel.run() | true |

Diagrams
=========

![Fiber class diagram](../../docs/diagrams/fiber_class_diagram.svg)

TODO
======

Say about side-effects.

