
The preferred editors are as follows,

- vim
- geany
- anjuta
- gedit

All of them has syntax highlighting.

#### Symbol traversing

Geany supports traversing the definition of symbols and jumping to the definitions. It can do that if the destination file is opened already.

Like the ctags used for c programming language, anjuta-tags works for vala programming language. 

```
make anjuta-tags
```

The command above will generate `tags` file in current directory. Provided the `tags` file, the vim editor can perform code jumping tasks easily.

