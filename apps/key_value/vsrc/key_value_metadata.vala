using aroop;

public errordomain key_value.error {
	end_of_data,
	write_failed,
}

public struct key_value.object {
	etxt name;
	etxt of;
	internal void parse(etxt*obj_expr) {
		of = etxt.from_etxt(obj_expr);
		of.shift(1);
		of.shift(-1);
		of.shift_token(" of ", &name);
		key_value.metadata.my_trim(&of);
		key_value.metadata.my_trim(&name);
	}
	internal void destroy() {
		name.destroy();
		of.destroy();
	}
}

public class key_value.metadata : Replicable {
	public etxt*the_key {get {return &our_key;}private set{}}
	public etxt*the_val {get {return &our_val;}private set{}}
	etxt our_key;
	etxt our_val;
	key_value.object our_object;
	line_reader reader;
	line_writer writer;
	
	static void my_ltrim(etxt*stream) {
		int i;

		// sanity check
		if(stream == null || stream.is_empty()) {
			return;
		}
		int ltrim = 0;
		for(i = 0; i < stream.length();i++) {
			char c = stream.char_at(i);
			if(c == ' ' || c == '\r' || c == '\n' || c == '\t') {
				ltrim++;
			} else {
				break;
			}
		}
		if(ltrim != 0) {
			stream.shift(ltrim);
		}
	}
	
	static void my_rtrim(etxt*stream) {
		int i;

		// sanity check
		if(stream == null || stream.is_empty()) {
			return;
		}
		int rtrim = 0;
		for(i = stream.length()-1;i > 0;i--) {
			char c = stream.char_at(i);
			if(c == ' ' || c == '\r' || c == '\n' || c == '\t') {
				rtrim--;
			} else {
				break;
			}
		}
		if(rtrim != 0) {
			stream.shift(rtrim);
		}
	}

	internal static void my_trim(etxt*stream) {
		my_ltrim(stream);
		my_rtrim(stream);
	}
	
	public metadata.parser(key_value.line_reader reader) {
		core.memclean_raw(this, sizeof(key_value.metadata));
		this.reader = reader;
	}

	public metadata.serializer(key_value.line_writer writer) {
		core.memclean_raw(this, sizeof(key_value.metadata));
		this.writer = writer;
		writer.buffer.buffer(128); // TODO see if memory is allocated
	}

	~metadata() {
		our_key.destroy();
		our_val.destroy();
		our_object.destroy();
	}

	static void my_trim_r(etxt*input, etxt*output) {
		(*output) = etxt.dup_etxt(input);
		my_trim(output);
	}

	public void next() throws key_value.error {
		while(true) {
			if(!our_key.is_empty()) {
				our_key.destroy();
			}
			if(!our_val.is_empty()) {
				our_val.destroy();
			}
			etxt line = etxt.EMPTY();
			reader.readline(&line);
			if(line.is_empty()) {
				throw new key_value.error.end_of_data("End");
			}
			if(line.char_at(0) == '[' && line.char_at(line.length()-1) == ']') {
				our_object.parse(&line);
				break;
			}
			our_val = etxt.from_etxt(&line);
			our_val.shift_token("=", &our_key);
			if(our_key.is_empty()) {
				continue;
			}
			my_trim(&our_key);
			my_trim(&our_val);
			break;
		}
	}

public key_value.object*next_object(etxt*given_objname) throws key_value.error {
	do {
		if(!our_object.name.is_empty()) {
			if(given_objname != null && our_object.name.equals(given_objname)) {
				our_object.destroy();
			} else {
				return &our_object;
			}
		}
		next();
	} while(true);
}

public void write_object(etxt*objname, etxt*owner) throws key_value.error {
	/* sanity check */
	if(objname == null || objname.is_empty()) {
		return;
	}
	etxt my_objname = etxt.EMPTY();
	my_trim_r(objname, &my_objname);
	my_objname.zero_terminate();
	if(owner == null || owner.is_empty()) {
		etxt my_owner = etxt.EMPTY();
		my_trim_r(owner, &my_owner);
		my_owner.zero_terminate();
		writer.buffer.printf_extra("[%T of %T]\n", &my_objname, &my_owner);
		my_owner.destroy();
	} else {
		writer.buffer.printf_extra("[%T]\n", &my_objname);
	}
	my_objname.destroy();
	writer.write();
}

public void write_string(etxt*key, etxt*val) throws key_value.error {
	etxt my_key = etxt.EMPTY();
	etxt my_val = etxt.EMPTY();
	my_trim_r(key, &my_key);
	my_trim_r(val, &my_val);
	my_key.zero_terminate();
	my_val.zero_terminate();
	writer.buffer.printf_extra("%T=%T\n", &my_key, &my_val);
	my_key.destroy();
	my_val.destroy();
	writer.write();
}

public void write_int(etxt*key, int val) throws key_value.error {
	etxt my_key = etxt.EMPTY();
	my_trim_r(key, &my_key);
	my_key.zero_terminate();
	writer.buffer.printf_extra("%T=%d\n", &my_key, val);
	my_key.destroy();
	writer.write();
}


#if key_value_parser_TEST
int main() {
	char*key_value.data = "garbage\r\n"
		"[nothing]\r\n"
		"[key_value.parser of any]\r\n"
			"test=successful\r\n"
			";hight=10\r\n";
	char*parsed_value = NULL;
	opp_str2system_init();
	struct key_value.config*config = key_value.parser_from_buffer(key_value.data);
	if(!config) {
		printf("Could not parse config");
		_exit(-1);
	}
	struct key_value.object*object = key_value.parser_object(config, NULL);
	SYNC_ASSERT(object && object->name && !strcasecmp(object->name, "nothing") && object->of == NULL);
	object = key_value.parser_object(config, "nothing");
	SYNC_ASSERT(object && object->name && !strcasecmp(object->name, "key_value.parser"));
	SYNC_ASSERT(object->of && !strcasecmp(object->of, "any"));
	printf("object:%s\n", object->name);
	printf("of:%s\n", object->of);
	while(!key_value.parser_next(config)) {
		if(!key_value.parser_get_value(config)) {
			continue;
		}
		if(!strcasecmp(key_value.parser_get_key(config), "test")) {
			opp_str2_dup2(&parsed_value, key_value.parser_get_value(config));
		}
		printf("key:%s,value:%s\n", key_value.parser_get_key(config), key_value.parser_get_value(config));
	}
	object = key_value.parser_object(config, object->name);
	SYNC_ASSERT(!object);
	key_value.deinit(&config);
	SYNC_ASSERT(parsed_value && !strcasecmp(parsed_value, "successful"));
	if(parsed_value) {
		OPPUNREF(parsed_value);
	}

	config = key_value.writer_to_file("./test.conf");
	key_value.writer_object(config, "shuva", "account");
	key_value.writer_string(config, "name", "shuva");
	key_value.writer_int(config, "id", 1);
	key_value.deinit(&config);

	config = key_value.parser_from_file("./test.conf");
	object = key_value.parser_object(config, NULL);
	SYNC_ASSERT(object && object->name && !strcasecmp(object->name, "shuva") && object->of && !strcasecmp(object->of, "account"));
	key_value.parser_next(config);
	SYNC_ASSERT(!strcasecmp(key_value.parser_get_key(config), "name") && !strcasecmp(key_value.parser_get_value(config), "shuva"));
	key_value.deinit(&config);
	config = key_value.writer_to_file("/public/static/void/insane.conf");
	SYNC_ASSERT(config == NULL);
	return 0;
}
#endif

}
