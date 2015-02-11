instant
=======

Shotodol instant is binary package creator, downloader and distributor.

#### How it works

- It keeps all the module list in .instant directory.
- The .instant/list.ske contains all the module properties. These files are parsed using the config file parser.
	- The basic properties of the modules are,
		- homepage
		- url
		- sha1
		- files
- executing a list.ske rule may install the target module.
