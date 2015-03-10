xtring
=======

Please refer to [core api](https://github.com/kamanashisroy/aroop/blob/master/aroop/vapi/README.md) for string types and string manipulation.

#### printing to standard output

The print() function works almost like the printf() function in C. The following code prints "Hello world" to the standard output.

```vala
extring hello = extring.set_static_string("Hello world");
print("%s\n", hello.to_string()); // print content to standard output
```

#### Scanner

Scanner contains static methods to traverse a string and get the tokens. For example, to parse a word from sentence "Good luck, have a nice day.", the next_token() can be used.

```vala
bool test_tokenize_simple() {
	extring buf = extring.stack(128);
	extring sentence = extring.set_static_string("Good luck, have a nice day.");
	extring word = extring();
	int i = 0;
	while(Scanner.next_token(&sentence, &word) == 0) {
		i++;
		buf.concat_string("Token:[");
		buf.concat(&word);
		buf.concat_string("],left:[");
		buf.concat(&sentence);
		buf.concat_string("]");
		buf.zero_terminate();
		print("%s\n", buf.to_string());
		buf.truncate();
		if(sentence.is_empty())
			break;
	}
	return i == 6;
}
```

The code above is in the _ScannerUnitTest.vala_ . Unit test entry `unit -t libs/str_arms` displays the following output for the code above.

```
Token:[Good],left:[ luck, have a nice day.]
Token:[luck,],left:[ have a nice day.]
Token:[have],left:[ a nice day.]
Token:[a],left:[ nice day.]
Token:[nice],left:[ day.]
Token:[day.],left:[]
```

