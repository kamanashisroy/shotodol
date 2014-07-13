Hooking
========

Hooks allow you to respond to specific event. You can write an extension to advertise your hook. This is a way of message passing.


Example
========

The _good\_luck_ module registers at _onQuit_ event. 

[Hooking.dot](Hooking.dot)

Please see the [GoodLuckModule.vala](../../apps/good_luck/vsrc/GoodLuckModule.vala) and [readme](../../apps/good_luck/README.md) . Programmatically `Plugin.swarm(eventName, null, null)` will swarm over the extensions registered for the specific event. You can achieve the same result typing `plugin -x eventName -act` in the shake shell.
