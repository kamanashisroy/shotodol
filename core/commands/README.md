Command
=========

![command component](../../docs/diagrams/command_component.svg)


Commands are the instructions for user interaction. A command can be interacted via [console](../console/README.md) or they can be used in [shake script](../shake/README.md). Typing 'help' in console shows the available commands. It is possible to write [custom commands](#custom_commands).

ModuleCommand
=============
Module command lets you load a dynamic module and also unloading it. Write `help module` for further details.

RehashCommand
=============
Rehash command lets the rehash extensions dispatch in a swarm.

Diagram
========

![Command hierarchy](../../docs/diagrams/command_hierarchy.svg)

Custom command
===============
This can be done by writing an [extension](../../libs/plugin/README.md) in _'command'_ space. Please refer to the [good luck module](../../apps/good_luck/) for an example of command.
