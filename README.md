![icon](https://cloud.githubusercontent.com/assets/973414/4041121/6f1fdb82-2cf1-11e4-9bae-255ca34f309f.jpg)

Shotodol
========

This is an all in one **server environment** written in [aroop](https://github.com/kamanashisroy/aroop)(aka [Vala programming language](https://wiki.gnome.org/Projects/Vala) with aroop profile). The target of the project is to provide,

- A [_module_](http://en.wikipedia.org/wiki/Module_%28programming%29) writing system to extend existing functionality.
- An interface(plugin system) where the modules communicate.
- An [interface](http://en.wikipedia.org/wiki/Shell_%28computing%29) where the user can communicate.

The idea here is to provide you an environment to write your own service via modules. There are some modules available in seperate projects based on shotodol. But the shotodol itself is kept small and simple. It minimises the required information [overhead](http://en.wikipedia.org/wiki/Information_overload) to write plugin/feature.

The name _shotodol_ means hundred petals(literally) or the lotus flower. In our project the petals are analogical to modules and the flower itself is analogical to the shotodol environment which holds them(modules) together. [see name shotodol](docs/name_shotodol.md)  

[**Developer Tutorial**](docs/books/tutorial/README.md)

Dependencies
============

You need to get the following project sources,

- [aroop](https://github.com/kamanashisroy/aroop)


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
User interfacing with shotodol
==============================

### Interactive shell

Shotodol by default(though not mandatory) comes with a console interface. You can put text commands to do certain tasks. It is called shake shell. You can put _help_ command to know more about the available commands.

### Shake script

Shotodol comes with a builtin parser for shake script. You can basically load prepared command blocks by these script files and execute them when needed.


[More on Shake script.](core/shake/README.md)


Testing
========

There are some test cases in _'tests'_ directory. You can, for example, change directory to tests/core/profiler/server and _make_ to test the _profiler_.

Growing
========

Shotodol is meant to be grown by you. You can grow it by adding new <a href="libs/module/README.md">modules</a>. You can write user modules and add features. Basically they are done by writting extensions for _command_ space and other event spaces. The builtin modules are there as examples.

Design Patterns
================
- [Design patterns](docs/Design_Patterns.md)
- [Diagrams](docs/diagrams/README.md)

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
- [Shotodol tutorial](docs/books/tutorial/README.md)

