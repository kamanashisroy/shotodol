Plugin
=========
Plugin lets you write ready to use named extensions. You put your extension in named list using register() function. Other plugins can use that extension to do certain tasks.

You can build the extension instance using getInstance() method.

Example
========
The _'idle'_ module is a good example of plugin. It registers as _command_ . And the register is like,

```
command -> idle 
```
And eventually the command is available in the console.

Readings
========

- External coupling
- Message passing
- [nixysa](https://code.google.com/p/nixysa/wiki/HelloWorldWalkThru)

