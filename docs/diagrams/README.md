
The idea of a diagram is to reduce cognitive load and cognitive dissonance. Here two standardized diagrams are used to investigate the project.

- [Class diagram](#Class_diagram)
- [Component diagram](#Component_diagram)


#### Class diagram

There are some class diagrams added to shotodol project for better understanding.

![fiber hierarchy](fiber_hierarchy.svg)
The above diagram shows the relation between differnt [fiber](../../libs/fiber)s.

#### Component diagram

Components here represent modules. It may also indicate any [M100Command](../../libs/make100) interface. 


The lollipop in the component diagram below is the plugin extension point.

![plugin hub](extended_interface.svg)

The half circular hub drawn above is the traversals of the extensions, ie, this is the place where the extensions are plugged.

![command console](shotodol_module_component_command_shell_full.svg)
The above diagram shows the available [commands](../../core/commands) and user [interaction](../../core/console).
![spawning process](spawning_process.svg)
The above diagram shows the method of [spawning child process](../../core/fork).

#### Other diagrams

![good_luck_module](https://cloud.githubusercontent.com/assets/973414/3932083/3024c45a-2464-11e4-8832-506e935eca7b.jpg)
![shotodol_architecture](https://cloud.githubusercontent.com/assets/973414/3930915/c45b8232-244e-11e4-9ced-f277e9d48729.jpg)
![shotodol_module_component_command_shell](https://cloud.githubusercontent.com/assets/973414/5547388/059c37fa-8b83-11e4-85e4-011b8210a619.jpg)

All the svg diagrams are in [docs/diagrams](./) directory.
