![icon](https://cloud.githubusercontent.com/assets/973414/4041121/6f1fdb82-2cf1-11e4-9bae-255ca34f309f.jpg)

Shotodol
========

This is an all in one **server environment** written in [aroop](https://github.com/kamanashisroy/aroop)(aka [Vala programming language](https://wiki.gnome.org/Projects/Vala) with aroop profile). The target of the project is to provide,

- A [_module_](http://en.wikipedia.org/wiki/Module_%28programming%29) writing system to extend existing functionality. [Read more.](docs/books/tutorial/module.md)
- An interface(plugin system) where the modules communicate. [Read more.](libs/plugin/README.md)
- An [interface](http://en.wikipedia.org/wiki/Shell_%28computing%29) where the user can communicate. [Read more.](core/console/README.md)

The idea here is to provide an environment to write a service via modules. There are some modules available in seperate projects based on shotodol. But the shotodol itself is kept small and simple. It minimises the required information [overhead](http://en.wikipedia.org/wiki/Information_overload) to write [plugin/feature](http://miniim.blogspot.com/2014/09/plugin.html). There is a [**tutorial**](docs/books/tutorial/README.md) to support the development.

The name _shotodol_ means hundred petals(literally) or the lotus flower. In our project the petals are analogical to modules and the flower itself is analogical to the shotodol environment which holds them(modules) together. [see name shotodol](docs/name_shotodol.md)  

In functional mathematics we define a function `f(x,y,z)` to be a relation between the _domains_ of _x_,_y_ and _z_ and the range of `f(x,y,z)`. Here shotodol can be defined like the following,

> shotodol = f(x,y,z, ...) where x,y and z are the extension points.

These extension points can be defined by plugins.

Visualizing shotodol 
=====================

Here is the artistic representation of shotodol core modules.

![shotodol_architecture](https://cloud.githubusercontent.com/assets/973414/3930915/c45b8232-244e-11e4-9ced-f277e9d48729.jpg)

The above diagram can be reduced to following mathematical function form,

- command is element of {quit,module,plugin,help,rehash}
- commandServer(command) is a function of command
- console(commandServer) function of commandServer 
- shotodol = f(console ..)

Here is the shotodol component diagram showing interaction between plugins.

![shotodol_module_component_command_shell](https://cloud.githubusercontent.com/assets/973414/5972668/ac8fc66e-a887-11e4-835e-d22b2d998ffd.jpg)

Preparation
============

- [Getting the sources](getting.md)
- [Building](building.md)

User interaction with shotodol
==============================

### Interactive shell

Shotodol by default(though not mandatory) comes with a console interface. User can put text commands to do certain tasks. It is called _shake_ shell. User can put _help_ command to know more about the available commands.

### Shake script

Shotodol comes with a builtin parser for shake script. It contains the shell commands discussed above listed under a rule. It is inspired by _Makefile_ rules. It basically loads prepared command blocks by these script files and execute them when needed.

[More on Shake script.](core/shake/README.md)

### Config files

FILLME

Growing
========

Shotodol is meant to be grown by the developers. It is possible to grow it by adding new <a href="libs/module/README.md">modules</a>. The modules generate plugins and interfaces to work togather. The builtin modules are there as examples.

- [more on modules](docs/books/tutorial/module.md)
- [Design patterns](docs/books/tutorial/design_patterns.md)
- [Diagrams](docs/diagrams/README.md)

Debugging
==========

- [Debugging](docs/books/tutorial/debugging.md)
- Testing There are some test cases in _'tests'_ directory. User can , for example, change directory to tests/core/profiler/server and _make_ to test the _profiler_.

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
- [Architecture of opensource applications](http://aosabook.org/en/index.html)
- [Simple English](http://simple.wikipedia.org/wiki/Wikipedia:How_to_write_Simple_English_pages)

Documentation
===============
- [Shotodol tutorial](docs/books/tutorial/README.md)

