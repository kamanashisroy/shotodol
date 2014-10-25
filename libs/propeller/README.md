Propeller
==========

Concurrency is achieved in shotodol using _Turbine_, _Propeller_ and _Spindle_. It has both preemptive and non-preemptive multitasking. 

[Propeller](vsrc/propeller.vala) is a thread. It is collection of spindles. And it executes the _step()_ method of registered [Spindles](vsrc/spindle.vala) one by one. If _step()_ returns nonzero then it is oust from the execution line. 

[Turbine](../turbine/vsrc/Turbine.vala) is a _Propeller_ that integrates the platform thread library. An application may contain only main thread which can perform _Propeller_ without the need of _Turbine_ . Otherwise if it contains multiple threads, it will need _Turbine_ to create them. 

### Call flow

_Propeller_ has following important methods as listed here. 

- start()
- stop()
- step()
- run()
- cancel()

These methods relate to _Spindle_ methods as listed here.

- start()
- step()
- cancel()

Again the _Turbine_ has some important methods as listed below.

- startup()

The relation to these methods and the call-flow is shown below.

| Component | Called methods |
|:--------------- |:-------|
|Turbine.startup() | Propeller.start() |
|Propeller.start() | Spindle.start(),Propeller.run() |
|Propeller.run() | Propeller.step() |
|Propeller.step() | Spindle.step() |

In the table above it is clear, that _Propeller_ can be started from _main()_ calling just _start()_ method. And when it returns the thread exits.

### Atomicity

The step() method in a _Spindle_ is executed one by one by _Propeller_. So it is atomic in respect to the _Propeller_. The table below lists who is atomic in respect to what.

| Component | Atomicity | In relation to |
|:----------------|:-------------|:------------------|
|_Spindle.step()_|atomic|Owner _Propeller_ and other _spindles_ inside it.|
|_Spindle.step()_|non-atomic|Multi-threaded application|
|_Propeller.run()_|atomic|_Turbine_|
|_Propeller.run()_|non-atomic|Multi-threaded application |

### Preemptive

Shotodol incorporates both preemptive and non-preemptive way to execute instructions. The _Propeller_ and _Spindle_ are both non-preemptive, while the _Turbine_ execution is preemptive. 

| Component | Preemptive |
|:----------------|:---------------|
| Propeller.run() | false |
| Propeller.step() | false |
| Spindle.step() | false |
| Turbine.run() | true |

TODO
======

Say about side-effects.

