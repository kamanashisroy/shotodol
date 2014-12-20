![icon](https://cloud.githubusercontent.com/assets/973414/4041121/6f1fdb82-2cf1-11e4-9bae-255ca34f309f.jpg)

Shotodol
========

This is an all in one **server environment** written in [aroop](https://github.com/kamanashisroy/aroop)(aka [Vala programming language](https://wiki.gnome.org/Projects/Vala) with aroop profile). The target of the project is to provide,

- A [_module_](http://en.wikipedia.org/wiki/Module_%28programming%29) writing system to extend existing functionality.
- An interface(plugin system) where the modules communicate.
- An [interface](http://en.wikipedia.org/wiki/Shell_%28computing%29) where the user can communicate.

The idea here is to provide you an environment to write your own service via modules. There are some modules available in seperate projects based on shotodol. But the shotodol itself is kept small and simple. It minimises the required information [overhead](http://en.wikipedia.org/wiki/Information_overload) to write plugin/feature.

The name _shotodol_ means hundred petals(literally) or the lotus flower. In our project the petals are analogical to modules and the flower itself is analogical to the shotodol environment which holds them(modules) together. [see name shotodol](docs/name_shotodol.md)  

Dependencies
============

You need to get the following project sources,

- [aroop](https://github.com/kamanashisroy/aroop)


Module
========

Most of the code done in shotodol are in modules, simply to achieve **[robustness](http://en.wikipedia.org/wiki/Structural_robustness)** by **[separation of concern](http://en.wikipedia.org/wiki/Separation_of_concerns)**. A module is a [group of code](http://en.wikipedia.org/wiki/Encapsulation_%28object-oriented_programming%29) that provides a functional support to the shotodol environment. You can say the following things about shotodol modules,

- Each module is contained in a discrete directory. There are helper _Makefiles_ to build the modules. These scripts are primed for building modules in depth of two directories. For example, you can write modules in apps/good\_luck or core/commands directory. 
- You may choose to load a module dinamically and unload dinamically. Though there are ways to load static libraries. The idea to load or initiate a module is to let it register the services or add extensions as plugin and do other initialization tasks. This is a way to support lazy initialization too.

Conceptually the modules should achieve more [cohesion](http://en.wikipedia.org/wiki/Cohesion_%28computer_science%29) and low [coupling](http://en.wikipedia.org/wiki/Coupling_%28computer_science%29).

Module Interaction
===================

The modules can communicate with each other. There are several ways to communicate,

### Shake script

_shake_ script provides a way to perform a task on an event. For example, there is an event like, onload. So when shotodol loads itself, it performs the onload tasks. A module can eventually generate events of their own(<a href="apps/shakeeventexample/README.md">example yet to come</a>).

### Plugin/extensions

You can write extensions and use them to communicate through them using interfaces. <a href="libs/plugin/README.md">Here is how.</a>

### Message passing.

The plugins/extensions allow you to write hooks for events. See <a href="libs/plugin/Hooking.md">hooking and message passing</a>.

![shotodol_architecture](https://cloud.githubusercontent.com/assets/973414/3930915/c45b8232-244e-11e4-9ced-f277e9d48729.jpg)

In the diagram above, _Quit_, _Module_, _Plugin_, _Help_, _Rehash_ are registered as commands in _plugin_ system. _Command server_ makes them available for use as instructions in _command/server_ extension point. And _Console module_(interactive shell) uses the _command server_ to access the commands.

Builtin Modules
===============

Shotodol comes with some builtin modules to support more extensions. These modules are namely,

### Basic modules

- [module](libs/module/README.md)
- [plugin](libs/plugin/README.md)
- [make100](libs/make100/README.md)

### Configuration modules

- [config](libs/config/README.md)

### Concurrency/process/thread management modules

- [propeller](libs/propeller/README.md)
- [turbine](libs/turbine/README.md)
- [fork](core/fork/README.md)

### Testing and benchmarking modules

- [profiler](core/profiler/README.md)
- [unittest](libs/unittest/README.md)
- [benchmark](libs/benchmark/README.md)
- [watchdog](libs/watchdog/README.md)

### IO modules

- [iostream](libs/iostream/README.md)

### Scripting modules

- [Shotodol Script](https://github.com/kamanashisroy/shotodol_script)
- [shake](core/shake/README.md)

### Packeting modules

- [bundle](libs/bundle/README.md)

### Unsorted modules

- [str\_arms](libs/str_arms/README.md)
- [iterator](libs/iterator/README.md)

### Instrumentation modules

- [profiler](core/profiler/README.md)
- [watchdog](libs/watchdog/README.md)

User module
============

User modules have the same potential as the builtin modules. But the point is, they are yours to write. <a href="libs/module/README.md">Here</a> is more about writing an user module.


User interfacing with shotodol
==============================

### Interactive shell

Shotodol by default(though not mandatory) comes with a console interface. You can put text commands to do certain tasks. It is called shake shell. You can put _help_ command to know more about the available commands.

### Shake script

Shotodol comes with a builtin parser for shake script. You can basically load prepared command blocks by these script files and execute them when needed.

<a href="core/shake/README.md">More on Shake script</a>


How to configure
===============

You need to build the aroop first. Please see the readme in aroop to build it.

To build shotodol, you need to configure and generate the makefiles. To do that you need [lua](http://www.lua.org/). And if you have filesystems module in lua then it will be easy. You need to execute the configure.lua script, like the following,

```
 a/shotodol$ lua configure.lua
```

And you will get the output like the following,

```
Project path /a/shotodol > 
Aroop path /a/aroop > 
enable bluetooth ?(y/n) > n
enable debug (ggdb3) ?(y/n) > y
```

Building shotodol
=================

Now, after you have the _Makefile_ in the shotodol directory you are ready to [_build_](http://en.wikipedia.org/wiki/Software_build). You can easily build it like,

```
 a/shotodol$ make
 a/shotodol$ ls
	shotodol.bin
```

The above command will create shotodol.bin as an executable binary. It reads the _autoload/shotodol.ske_ (_shake_ script file) for loading required plugins and execute other command blocks. 

Running
========

You can execute shotodol by running the shotodol.bin file.

```
 a/shotodol$ ./shotodol.bin
```

Testing
========

There are some test cases in _'tests'_ directory. You can, for example, change directory to tests/core/profiler/server and _make_ to test the _profiler_.

Growing
========

Shotodol is meant to be grown by you. You can grow it by adding new <a href="libs/module/README.md">modules</a>. You can write user modules and add features. Basically they are done by writting extensions for _command_ space and other event spaces. The builtin modules are there as examples.

Design Patterns
================
- [Design patterns](docs/Design_Patterns.md)
- [Diagrams](docs/diagrams.md)

Debugging
==========
- [Debugging](docs/debugging.md)

Tasks
======

[Tasks](TASKS.md)

Public projects
===============

There are some public projects based on shotodol. They are namely,

- [Shotodol Script](https://github.com/kamanashisroy/shotodol_script)
- [Shotodol Net](https://github.com/kamanashisroy/shotodol_net)
- [Shotodol Web](https://github.com/kamanashisroy/shotodol_web)
- [Shotodol DB](https://github.com/kamanashisroy/shotodol_db)
- [Shotodol Media](https://github.com/kamanashisroy/shotodol_media)
- [Roopkotha](https://github.com/kamanashisroy/roopkotha)
- [Onubodh](https://github.com/kamanashisroy/onubodh)

Readings
=========

- [Vala](https://wiki.gnome.org/Projects/Vala)
- [Unix philosophy](http://en.wikipedia.org/wiki/Unix_philosophy)
- [Inversion of control](http://en.wikipedia.org/wiki/Inversion_of_control)
- [The idea of Plugin](http://miniim.blogspot.com/2014/09/plugin.html)

Documentation
===============
- [Simple English](http://simple.wikipedia.org/wiki/Wikipedia:How_to_write_Simple_English_pages)
- [Architecture of opensource applications](http://aosabook.org/en/index.html)

