Roadmap
========

- [x] Write an example to demonstrate hooking.
- [ ] Fix the crash bug on exit.
	- [ ] Fix the reference bug in generics.
- [ ] Write profiler checking command.
- [ ] Write an example to generate a custom event/task.
- [x] Fill the README.md for the console module.
- [ ] Write a console module to connect to another console of shotodol as unix socket client.
- [ ] Allow module info in the vala comment or a seperate file.
- [x] Keep the modules in namespace like directory.
- [ ] Know more about dbus and systemd projects.
- [x] Add support for module writing in lua. 
	- Load lua library and load lua hooks by function. They can communicate with the program using message passing.
	- Add a module function to load script modules.
- [x] Rename str to xtring.
- [x] Finish up the primary messaging code, named, pollen.
- [ ] Add a homebrew package.(Is it feasible ?)
- [x] Implement infix/prefix bundlers.
- [ ] Implement major,minor,patch,release versioning.
- [ ] Profile memory move/copy events(with the memory size). It can be done in for example extring.copy_on_demand implementations.
	- See zero copy memory management in gstreamer.
- [ ] Implement green threads/coroutine. Spindle.longRun() instread of Spindle.step() may reduce the setup execution cost in each call.
	- Use generators.
- [ ] Add tagging support in watchdog log.
- [x] see if there is any object of a class of a module still exists in any_obj_factory after unloading the module.
- [x] Keep shotodol bare minimum. Move extra modules in other projects.
- [ ] Integrate python.
