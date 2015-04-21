Plugin
=========
Plugin is a way to write ready to use named extensions. The idea is to advertise the extension in named list using register() function. Other components can use that extension to do certain tasks.

Plugin techniques
==================

### Extension point or plugin spaces
Extension points or plugin spaces are the names to locate a service or extension. Each plugin _space_ is a string. See [service locator](http://en.wikipedia.org/wiki/Service_locator_pattern).

![Advertising Extension point](../../docs/diagrams/advertising_extension_point.svg)

### Extension
_Extension_ is a way to associate your facility to a plugin space. Suppose if you want to write a _command_ then you need to register an _extension_ in space named _'command'_ . All the extensions have an _act()_ method available for communication. 

### Interface
_Interface_ in an _extension_ is an _object_ returned by getInterface() method. You can type-cast this _object_(Replicable) into something that meet your purpose. Once a _plugin_ registers an _interface_, it is mapped when _rehash_ is done. For example, the commands module loads all the commands under the name space "command" and makes them available for user. Notably, all the commands inherit M100Command class. This is an example of [design by contract](http://en.wikipedia.org/wiki/Design_by_contract). Interface here allows better performance than hooking technique. On the other hand, this kind of extensions implements the idea of [dependency injection](http://en.wikipedia.org/wiki/Dependency_injection).

![Interface accessing](../../docs/diagrams/extended_interface.svg)

### Hooking
[Hook function](Hooking.md) is invoked by the extension point or the event name.


![Calling/swarming the extended hook](../../docs/diagrams/swarming_extended_hook.svg)

### Class diagram

![Plugin Class Diagram](../../docs/diagrams/plugin_class_diagram.svg)


### rehash

Rehash is an event. This event is generated from [rehash command](../../core/commands/README.md#RehashCommand). It asks everyone to get the extensions from plugin name space and get the insterface for future use. Rehash is done normally after a module load or unload. (May be we need to do rehash when there is any change in plugin).

![rehash diagram](../../docs/diagrams/rehash.svg)



### Cheat sheet


[Pluginoid cheat sheet](pluginoid.dot)



![Pluginoid cheat sheet](dot_generated_pluginoid.svg)



Composite techniques
======================

Plugin system contains collection of extensions. It is a [composite pattern](http://en.wikipedia.org/wiki/Composite_pattern). You can summon them using _swarm_ and _acceptVisitor_ method.
- `swarm` method is in fact a collective [message passing](http://en.wikipedia.org/wiki/Message_Passing) technique. It sends message to each of the extensions under a namespace.
- `acceptVisitor` method lets you do your task/instructions for each of the extensions hooked in a namespace.

Example
========
The _'idle'_ module is a good example of plugin. It registers as _command_. And eventually the command is available in the console.

Plugin queries
================
The plugin command enables us to see the loaded extensions and associated modules.

### Listing
```
plugin -x command
```
The above command will show all the registered commands. 

### Dispatch

A hook can be called from commandline. It is like dispatching an event. The following command dispatches *onQuit* event.

```
plugin -x onQuit -act
```
The above command will execute the extensions/hooks in _'onQuit'_ name space.

Loading and unloading plugins
==============================
Plugins are loaded when the module is loaded. But you can disable/enable a plugin using commands. (well it is not yet implemented at the time of writing this README, it should be something like `plugin -x plspace -dis`) . See the [module command](../../core/commands/README.md#ModuleCommand).

Readings
========

- External coupling
- Message passing
- [Interface](http://en.wikipedia.org/wiki/Interface_%28computing%29)
- [Hook](http://en.wikipedia.org/wiki/Hooking)
- [nixysa](https://code.google.com/p/nixysa/wiki/HelloWorldWalkThru)
- [Plugin](http://miniim.blogspot.com/2014/09/plugin.html)
- [libpeas](https://wiki.gnome.org/Projects/Libpeas)

