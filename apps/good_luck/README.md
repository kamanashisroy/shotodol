Good Luck Module
=================

'Good luck' module is simple module to demonostrate module writing. Note that there are kinds of modules, while this module is dynamic. If you want to write a module like this, you need to create a directory in apps (favorablly).

```
 a/shotodol$ mkdir apps/good\_luck
```

Now you need to create the following files there.

- pkg.depend : This file identifies the needed modules.
- includes.mk : This file shows the include path.
- vapi.mk : This is for compilation.

You may follow the files for _good\_luck_ to write your own module files.

Now you need to add the vala source files. Vala sources are kept in _vsrc_ directory. 

```
 a/shotodol$ mkdir apps/good\_luck/vsrc
```

The [GoodLuckModule.vala](vsrc/GoodLuckModule.vala) defines the GoodLuckModule class. Please refer to [Hooking](../../libs/plugin/Hooking.md) to understand the source.

```
 a/shotodol$ vim apps/good\_luck/vsrc/GoodLuckModule.vala
```

After you are done with the code, you need to add the module in build/pkg.depend file and reconfigure and compile.

```
 a/shotodol$ echo apps/good\_luck >> build/pkg.depend
 a/shotodol$ lua configure.lua
 a/shotodol$ make
 a/shotodol$ ls apps/good\_luck
	dynalib.so pkg.depend includes.mk vapi.mk vsrc/ vapi/ include/
```

The _dynalib.so_ contains the program definitions. You need to load this file using the _module_ command. After running/executing the ./shotodol.bin file, you will be prompted for your commands. Write _'module -load apps/good\_luck/dynalib.so'_ to load the module for execution(see [commands](../../core/commands/README.md)). The module will eventually be ready for use. 

```
 a/shotodol$ ./shotodol.bin
	module -load apps/good_luck/dynalib.so
```

Now when you quit the application by writing _quit_ command, it will say you 'Good Luck'.

```
 a/shotodol$ ./shotodol.bin
	module -load apps/good_luck/dynalib.so
	quit
	Good Luck
```

I hope this _good\_luck module reveals a lot of shotodol basics.

