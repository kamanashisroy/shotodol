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

Hooking
========

You can write a [hook function](Hooking.md) for an event.

Readings
========

- External coupling
- Message passing
- [Interface](http://en.wikipedia.org/wiki/Interface_%28computing%29)
- [Hook](http://en.wikipedia.org/wiki/Hooking)
- [nixysa](https://code.google.com/p/nixysa/wiki/HelloWorldWalkThru)

