Console
========

[Console](http://en.wikipedia.org/wiki/Command-line_interface) lets you to communicate with shotodol application in interactive way. The console is called shake shell . It is based on unix philosophy (write programs to handle text streams, because that is a universal interface.). You can also load [shake shell](../shake/README.md) and execute a target here. Use the _help_ command to know more about a command.

```
 help commandname
```

To execute a command you need to type the full name (sometimes partial will work) of the command followed by the arguments. For example, if you want to print something you may use _'echo'_ command. You just need to write _echo_ followed by your message to print it out.

```
 echo Hello World
```

The above command will print 'Hello World' as output.

Loaded by default
==================

The console module is loaded by default. So when shotodol.bin starts executing it lets user to interact it via a console.

Future Plan
============

We have plans to write remote consoles over a network and unix socket based console. We have plans to add command line argument for allowing user to choose the console to load.

