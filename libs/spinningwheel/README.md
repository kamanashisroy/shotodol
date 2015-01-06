SpinningWheel
========

[SpinningWheel](vsrc/SpinningWheel.vala) is a _Fiber_ collection that integrates the platform thread library. An application may contain only main thread which can perform _Fiber_  collection without the need of _SpinningWheel_ . Otherwise if it contains multiple threads, it will need _SpinningWheel_ to create them. 

See also
=========

[Fiber](../fiber/README.md)
 
