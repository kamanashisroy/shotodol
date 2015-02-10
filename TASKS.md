Roadmap
========

#### Framework
- [x] Write an example to demonstrate hooking.
- [ ] Write an example to generate a custom event/task.
- [x] Fill the README.md for the console module.
- [x] Rename str to xtring.
- [x] Keep shotodol bare minimum. Move extra modules in other projects.
	- [x] Move lua scripting into separate shotodol_script package.

#### Command
- [ ] Write a quiet command server in "command/server" space.
- [ ] Write support for command description.

#### Messaging
- [x] Finish up the primary messaging code, named, pollen.
	- [x] Rename it to Bag.
	- [ ] Write detailed documentation for _Bag_ and _Bundler_.
	- [ ] write Replicable.bundle(Bag) or Replicate.update(Bag);
- [x] Implement infix/prefix bundlers.


#### Concurrency
- [ ] Implement green threads/coroutine. Fiber.longRun() instread of Fiber.step() may reduce the setup execution cost in each call.
	- [ ] Use generators.
- [x] Implement forking and associate different console with a pipe to the parent process.
	- [x] Create jobs console command like in unix shell.
	- [ ] Use fg,bg command to change or select target process.
	- [x] Use https://en.wikipedia.org/wiki/Cell_%28microprocessor%29#Distributed_computing
- [ ] Remove all the locks, lower the atomic operations.

#### Packaging
- [ ] Study node.js modules.
	- [ ] Study a basic [addon](http://www.nodejs.org/api/addons.html).
- [ ] Allow module info in the vala comment or a seperate file.
	- [ ] Apply sort of stability index like [this](http://www.nodejs.org/api/documentation.html).
	- [ ] Implement major,minor,patch,release versioning.
- [x] Keep the modules in namespace like directory.
- [ ] Add a homebrew package.(Is it feasible ?). Or we may write bricks/rocks packages.

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

#### Tutorial
- [x] Write an elaborative tutorial.
	- [x] Move some of the contents of the main README.md file into tutorial.
