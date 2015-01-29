Shotodol programming and design patterns
=========================================

#### Encapsulation

[Modules](../../../libs/module/README.md) provide encapsulation in shotodol. You can hide your inner workings in modules and still be able to advertise your extensions registering as [plugins](../../../libs/plugin/README.md).

#### Composite Pattern

Writing extensions in a plugin space is an example of composite pattern. See [extensions](../../../libs/plugin/README.md#extension).


The following diagram displays the composition of commands under _command/server_ .

![Composite class diagram for commands](../../../docs/diagrams/composite_class_diagram_for_commands.svg)


The following diagram displays the composition of fibers.

![Composite class diagram for fibers](../../../docs/diagrams/composite_class_diagram_for_fibers.svg)


#### Inheritance

The [bundler](../../../libs/bundler/) has an inheritance pattern.

#### Readings

- [Plugin Oriented programming](http://miniim.blogspot.com/2014/09/plugin.html)
- [Data Oriented programming talk](github.com/kamanashisroy/aroop/tree/master/talks/data_oriented_talks)
- [Drupal OOP](https://www.drupal.org/node/547518)
- [When OOP do not fit](http://technosophos.com/2010/10/13/why-object-oriented-programming-bad-drupal.html)
