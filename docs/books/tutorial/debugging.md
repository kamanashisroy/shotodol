
Debugging shotodol
===================

A framework is simple for developer if the developer can narrow down the suspected region for finding bug. Shotodol provides module system and [unit testing](../../../libs/unittest) framework to write tested code and modules.

Again there are compiler flags for printing debug output. It is possible to enable debugging while configuring(lua configure.lua). 

#### Memory Debugging

Memory debugging technique in shotodol is primarilly done in the following ways.

- Module load and unload testing

### Module load and unload testing

This is a way of debugging shotodol memmory. A module is loaded and executed and then unloaded. While unloading the module it is checked for objects left in object system. There is a core method to do this `core.assert_no_module(module_name)`. See the ModuleLoader.vala unloadModuleByName() method. Note, to use this feature you need to set debugging on while configuring(lua configure.lua).

#### Using gdb

You can load shotodol.bin in gdb and execute it. Suppose you have an assert failure then you can trace that easilly . See below an advanced example.

```
The module core/shake left an object of aroop_cl_shake_command class
shotodol.bin: src/opp_any_obj.c:100: opp_any_obj_assert_no_module_helper: Assertion '0' failed.

Program received signal SIGABRT, Aborted.
0x00007ffff761f425 in __GI_raise (sig=<optimized out>) at ../nptl/sysdeps/unix/sysv/linux/raise.c:64
64	../nptl/sysdeps/unix/sysv/linux/raise.c: No such file or directory.
(gdb) bt
#0  0x00007ffff761f425 in __GI_raise (sig=<optimized out>) at ../nptl/sysdeps/unix/sysv/linux/raise.c:64
#1  0x00007ffff7622b8b in __GI_abort () at abort.c:91
#2  0x00007ffff76180ee in __assert_fail_base (fmt=<optimized out>, assertion=0x44c719 "0", file=0x44c6e1 "src/opp_any_obj.c", line=<optimized out>, 
    function=<optimized out>) at assert.c:94
#3  0x00007ffff7618192 in __GI___assert_fail (assertion=0x44c719 "0", file=0x44c6e1 "src/opp_any_obj.c", line=100, 
    function=0x44c940 "opp_any_obj_assert_no_module_helper") at assert.c:103
#4  0x000000000043eeb4 in opp_any_obj_assert_no_module_helper (func_data=0x70d578, content=0x72d2a8) at src/opp_any_obj.c:100
#5  0x0000000000442af3 in opp_factory_do_full (obuff=0x655360, obj_do=0x43ecd0 <opp_any_obj_assert_no_module_helper>, func_data=0x70d578, if_flag=32768, 
    if_not_flag=0, hash=0) at src/opp_factory.c:1769
#6  0x000000000043f013 in opp_any_obj_assert_no_module (module_name=0x70d578 "core/shake") at src/opp_any_obj.c:107
#7  0x0000000000413ddf in aroop_cl_shotodol_shotodol_module_loader_unloadModuleByName (self_data=0x678238, givenModuleName=0x7fffffffe6a0, pad=0x0)
    at vsrc/BaseModule.c:934
#8  0x0000000000413267 in aroop_cl_shotodol_shotodol_module_loader_unloadAll (self_data=0x678238) at vsrc/BaseModule.c:817
#9  0x000000000040d8f1 in aroop_cl_shotodol_shotodol_main_program_main () at vsrc/Main.c:194
#10 0x000000000040d986 in main (argc=1, argv=0x7fffffffe818) at vsrc/Main.c:207
(gdb) f 4
#4  0x000000000043eeb4 in opp_any_obj_assert_no_module_helper (func_data=0x70d578, content=0x72d2a8) at src/opp_any_obj.c:100
100			SYNC_ASSERT(0);
(gdb) p *(((struct opp_object*)content)-1)
$1 = {bit_idx = 20 '\024', slots = 2 '\002', refcount = 1, signature = 36, bitstring = 0x728da8, ref_trace = {{filename = 0x0, lineno = 0, refcount = 0, 
      op = 0 '\000', flags = "\000\000"}, {filename = 0x449b00 "vsrc/M100Block.c", lineno = 1512, refcount = 1, op = 43 '+', flags = "\000\000"}, {
      filename = 0x7ffff64bf440 "vsrc/ShakeCommand.c", lineno = 516, refcount = 2, op = 45 '-', flags = "\000\000"}, {
      filename = 0x449b00 "vsrc/M100Block.c", lineno = 1536, refcount = 1, op = 43 '+', flags = "\000\000"}, {filename = 0x449b00 "vsrc/M100Block.c", 
      lineno = 804, refcount = 2, op = 45 '-', flags = "\000\000"}, {filename = 0x449180 "vsrc/BrainEngine.c", lineno = 201, refcount = 1, op = 43 '+', 
      flags = "\000\000"}, {filename = 0x449180 "vsrc/BrainEngine.c", lineno = 203, refcount = 2, op = 43 '+', flags = "\000\000"}, {
      filename = 0x449b00 "vsrc/M100Block.c", lineno = 971, refcount = 3, op = 45 '-', flags = "\000\000"}, {filename = 0x449b00 "vsrc/M100Block.c", 
      lineno = 1536, refcount = 2, op = 43 '+', flags = "\000\000"}, {filename = 0x449b00 "vsrc/M100Block.c", lineno = 804, refcount = 3, op = 45 '-', 
      flags = "\000\000"}, {filename = 0x449b00 "vsrc/M100Block.c", lineno = 1450, refcount = 2, op = 45 '-', flags = "\000\000"}, {filename = 0x0, 
      lineno = 0, refcount = 0, op = 0 '\000', flags = "\000\000"} <repeats 21 times>}, rt_idx = 10, obuff = 0x655360}
```

