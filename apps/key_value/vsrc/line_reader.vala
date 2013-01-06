using aroop;
using Posix;


public errordomain key_value.line_reader_error {
	no_buffer,
	could_not_open_file,
}

public class key_value.line_reader : None {
	FILE?fp;
	etxt src;
	public line_reader.from_file(etxt*filename) throws key_value.line_reader_error {
		core.memclean_raw(this, sizeof(line_reader));
		fp = FILE.open(filename.to_string(), "r");
		if(fp == null) {
			throw new key_value.line_reader_error.could_not_open_file("Could not open file");
		}
	}

	public line_reader.from_buffer(etxt*buf/* This should be null terminated */) throws key_value.line_reader_error {
		core.memclean_raw(this, sizeof(line_reader));
		if(buf == null || buf.is_empty()) {
			throw new key_value.line_reader_error.no_buffer("buffer is empty");
		}
		src = etxt.dup_etxt(buf);
	}
	
	~line_reader() {
		src.destroy();
	}

	internal void readline(etxt*line) throws key_value.error {
		while(true) {
			if(fp != null) {
				line.destroy();
				None mem = core.memory_alloc(128);
				unowned string input = (string)mem;
				// sad that there is no bound checking ..
				if(fp.gets((char[])mem) == null) {
					throw new key_value.error.end_of_data("File end");
				}
				(*line) = etxt(input, mem);
			} else {
				src.shift_token("\n", line);
				if(line.is_empty()) {
					throw new key_value.error.end_of_data("Stream end");
				}
				key_value.metadata.my_trim(line);
			}
			if(!line.is_empty()) {
				if(line.char_at(0) == ';') { // skip the commented line
					line.destroy();
					continue;
				}
				break;
			}
		}
	}
}
