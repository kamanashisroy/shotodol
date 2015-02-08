xtring
=======

Please refer to [core api](https://github.com/kamanashisroy/aroop/blob/master/aroop/vapi/README.md).

#### printing to standard output

The print() function works almost like the printf() function in C. The following code prints "Hello world" to the standard output.

```vala
extring hello = extring.set_static_string("Hello world");
print("%s\n", hello.to_string()); // print content to standard output
```


