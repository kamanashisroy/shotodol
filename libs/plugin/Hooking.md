Hooking
========

Hooks allow you to respond to specific event. You can write an extension to advertise your hook. This is a way of message passing.


Example
========

The _good\_luck_ module registers at _onQuit_ event. 

[Hooking.dot](Hooking.dot)
![good_luck_module](https://cloud.githubusercontent.com/assets/973414/3932083/3024c45a-2464-11e4-8832-506e935eca7b.jpg)

Please see the [GoodLuckModule.vala](../../apps/good_luck/vsrc/GoodLuckModule.vala) and [readme](../../apps/good_luck/README.md) . Programmatically `Plugin.swarm(eventName, null, null)` will swarm over the extensions registered for the specific event. You can achieve the same result typing `plugin -x eventName -act` in the shake shell.
