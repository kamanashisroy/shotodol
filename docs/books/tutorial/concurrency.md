Concurrency
===========

It has both preemptive and non-preemptive multitasking.

[Propeller](../../../libs/propeller) is a thread. It is collection of _Spindles_. And it executes the _step()_ method of registered _Spindles_ one by one. If _step()_ returns nonzero then it is oust from the execution line.

[Turbine](../../../libs/turbine) is a _Propeller_ that integrates the platform thread library. An application may contain only main thread which can perform _Propeller_ without the need of _Turbine_ . Otherwise if it contains multiple threads, it will need _Turbine_ to create them.

Furthermore it is possible to [spawn new process](../../../core/fork/README.md).

