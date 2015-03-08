Roadmap
========

#### Framework
- [x] Write an example to demonstrate hooking.
- [x] Write an example to generate a custom event/task.
- [x] Fill the README.md for the console module.
- [x] Rename str to xtring.
- [x] Keep shotodol bare minimum. Move extra modules in other projects.
	- [x] Move lua scripting into separate shotodol_script package.
- [ ] State the cohesion type in README.md for each module in shotodol.

#### Command
- [ ] Write a quiet command server in "command/server" space.
- [x] Write support for command description. (It is already available)
- [x] Write an alias command such as it can create alias for some command. For example, `alias wa55 watchdog -l 100 -tag 55 ` will create a command alias named `zwa55` which will call `watchdog -l 100 -tag 55 ` in the background.
- [x] Write a status command to show server status.

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
- [ ] Add a fiber priority feature. Let it add priority based scheduling in addition to current round robin scheduling.
- [ ] Remove all the locks, lower the atomic operations.

#### Packaging
- [ ] Study node.js modules.
	- [ ] Study a basic [addon](http://www.nodejs.org/api/addons.html).
- [ ] Allow module info in the vala comment or a seperate file.
	- [ ] Apply sort of stability index like [this](http://www.nodejs.org/api/documentation.html).
	- [ ] Implement major,minor,patch,release versioning.
- [x] Keep the modules in namespace like directory.
- [x] Add a homebrew package.(Is it feasible ?). Or we may write bricks/rocks packages. We added 'instant' package for modules.
- [ ] Check license while loading a module.

#### Debugging

- [ ] Fix the crash bug on exit.
	- [ ] Fix the reference bug in generics.
- [ ] Write profiler checking command.
- [ ] Profile memory move/copy events(with the memory size). It can be done in for example extring.copy_on_demand implementations.
	- [ ] See zero copy memory management in gstreamer.
- [x] Add tagging support in watchdog log. (This is done using -tag parameter)
- [ ] Rename Watchdog.WatchdogSeverity to Watchdog.Severity .
- [x] see if there is any object of a class of a module still exists in any_obj_factory after unloading the module.

#### Decoupling
- [ ] Move all the platfrom dependent code into named extensions(see roopkotha guicore).

#### Tutorial
- [x] Write an elaborative tutorial.
	- [x] Move some of the contents of the main README.md file into tutorial.
- [ ] Write skeleton readme for Command, Module, Gateway, Hook etc ..
	- [x] Write skeleton for Module.
	- [x] Write skeleton for Command.
	- [x] Write skeleton for Hook.
