Roadmap
========

#### Framework
- [x] Write an example to demonstrate hooking.
- [ ] Write an example to generate a custom event/task.
- [x] Fill the README.md for the console module.
- [x] Rename str to xtring.
- [x] Keep shotodol bare minimum. Move extra modules in other projects.

#### Messaging
- [x] Finish up the primary messaging code, named, pollen.
	-[x] Rename it to Bag.
- [x] Implement infix/prefix bundlers.


#### Concurrency
- [ ] Implement green threads/coroutine. Spindle.longRun() instread of Spindle.step() may reduce the setup execution cost in each call.
	- [ ] Use generators.
- [x] Implement forking and associate different console with a pipe to the parent process.
	- [ ] Create jobs console command like in unix shell.
	- [ ] Use fg,bg command to change or select target process.
- [ ] Remove all the locks, lower the atomic operations.

#### Packaging
- [ ] Study node.js modules.
	- [ ] Study a basic [addon](http://www.nodejs.org/api/addons.html).
- [ ] Allow module info in the vala comment or a seperate file.
	- [ ] Apply sort of stability index like [this](http://www.nodejs.org/api/documentation.html).
	- [ ] Implement major,minor,patch,release versioning.
- [x] Keep the modules in namespace like directory.
- [ ] Add a homebrew package.(Is it feasible ?). Or we may write bricks/rocks packages.

#### Language support
- [ ] Integrate python.
	- [ ] Study 'Battle of wesnoth' and see how it integrates python.
- [x] Add support for module writing in lua. 
	- [ ] Load lua library and load lua hooks by function. They can communicate with the program using message passing.
	- [ ] Add a module function to load script modules.
	- [ ] Load additional lua script with _source_ command and still keep the old definitions.

#### Debugging

- [ ] Fix the crash bug on exit.
	- [ ] Fix the reference bug in generics.
- [ ] Write profiler checking command.
- [ ] Profile memory move/copy events(with the memory size). It can be done in for example extring.copy_on_demand implementations.
	- [ ] See zero copy memory management in gstreamer.
- [ ] Add tagging support in watchdog log.
- [x] see if there is any object of a class of a module still exists in any_obj_factory after unloading the module.

#### Decoupling
- [ ] Move all the platfrom dependent code into named extensions(see roopkotha guicore).
