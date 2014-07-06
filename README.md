Shotodol
========

This is an all in one server environment written in aroop(aka vala language with aroop profile). The target of the project is to provide,

- A _module_ writing system to extend existing functionality.
 - An interface where the user can communicate.
 - An interface where the modules communicate.


Modules
========

Most of the code done in shotodol are in modules. The modules are a group of code that provide a functional support to the shotodol environment. You can say the following things about shotodol modules,

- Each module is contained in a discrete directory. There are helper _Makefiles_ to build the modules. These scripts are primed for building modules in depth of two directories. For example, you can write modules in apps/net\_echo or core/command directory.
- You may choose to load a module dinamically and unload dinamically.

The modules can communicate with each other. There are several ways to communicate,

### Shake script

_shake_ script provides a way to perform a task on an event. For example, there is an event like, onload. So when shotodol loads itself, it performs the onload tasks. A module can eventually generate events of their own.

<a href="apps/shakeeventexample/README.md">Extending a module using shake events</a>

### Message bus.

<a href="libs/module/README.md">Writing a module</a>

### Extensions

You can write extensions and use them to communicate through them. 
<a href="libs/plugin/README.md">Here is how.</a>

User interfacing with shotodol
==============================

### Interactive shell

Shotodol by default(though not mandatory) comes with a console interface. You can put text commands to do certain tasks. It is called shake shell. You can put _help_ command to know more about the available commands.

### Shake script

Shotodol comes with a builtin parser for shake script. You can basically load prepared command blocks by these script files and execute them when needed.

<a href="core/shake/README.md">More on Shake script</a>

Readings
========

[nixysa](https://code.google.com/p/nixysa/wiki/HelloWorldWalkThru)

