Concurrency
===========

It has both preemptive and non-preemptive multitasking.

[Fiber](../../../libs/fiber) is a library for fibers. It has collection of fibers too. And it executes the _step()_ method of registered _Fiber_s one by one. If _step()_ returns nonzero then it is oust from the execution line.

[Turbine](../../../libs/turbine) is a _Fiber_ collection that integrates the platform thread library. An application may contain only main thread which can perform _Fiber_ without the need of _Turbine_ . Otherwise if it contains multiple threads, it will need _Turbine_ to create them.

Furthermore it is possible to [spawn new process](../../../core/fork/README.md).

