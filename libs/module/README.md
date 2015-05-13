Module
=========

![module component](../../docs/diagrams/module_component.svg)


Modules are the basic building block of the shotodol project. There are two kinds of modules in terms of loading point.

1. Static module : Static modules are linked statically to shotodol.bin (binary).
2. Dynamic module : Dynamic modules are loaded on demand.

Mostly the modules in [libs](../../libs),[linux](../../linux) directory are static libraries. These libraries are used by other modules (by subclassing or direct method call.). And the rest of the modules are dynamic modules. They are used as extensions(in some unavoidable cases they may be used in subclassing too). 

Both of the types of modules can be initiated on demand, allowing [lazy initialization](http://en.wikipedia.org/wiki/Lazy_initialization).

And there are two kinds of modules in terms of development and grouping.

1. Builtin module : This kind of modules are needed for the basic framework of shotodol.
2. User module : User module can be written by user to add new feature or alter existing.

Please see the [_good_luck_](../../apps/good_luck/README.md) module for an example of user modules.

There is more on modules in [tutorial pages](../../docs/books/tutorial/module.md).

