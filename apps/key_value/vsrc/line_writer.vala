using aroop;
using Posix;


public errordomain key_value.line_writer_error {
	could_not_open_file_for_writing,
}

public class key_value.line_writer : Replicable {
	FILE?fp;
	public etxt buffer;
	
	public line_writer.to_file(etxt*filename) throws key_value.line_writer_error {
		core.memclean_raw(this, sizeof(line_writer));
		fp = FILE.open(filename.to_string(), "w+");
		if(fp == null) {
			throw new key_value.line_writer_error.could_not_open_file_for_writing("Could not open file");
		}
		buffer = etxt.EMPTY();
	}
	
	~line_writer() {
		buffer.destroy();
	}
	
	internal void write() throws key_value.error {
		fp.puts(buffer.to_string());
	}
}
