Frequently asked questions
===========================

#### How to know all the extension points ?
It is possible to build documentation with doxygen. The doxygen ***should contain(TODO)** the list of all the extension points. It is suggested to go through the code for complete understanding.


Another way to get all the places where `Plugin.swarm()` method is called. It can be done by the following command,

```
find -iname "*.vala" | xargs grep swarm
```

The `swarm` can be traced to find the events and extension points.

