using aroop;
using shotodol;

/** \addtogroup str_arms
 *  @{
 */
public struct shotodol.Scanner {
	extring idelim;
	Scanner() {
		idelim = extring.set_static_string(" \n\r");
	}

	public static int next_token_delimitered_unused(extring*src, extring*next, extring*delim, extring*wordDivider = null) {
		uint i = 0;
		int token_start = -1;
		int trim_at = -1;
		int len = src.length();
		for(i = 0; i < len; i++) {
			uchar x = src.char_at(i);
			if((wordDivider == null && (x == ' ' || x == '\r' || x == '\n')) || wordDivider.contains_char(x)) {
				if(token_start == -1) {
					continue;
				}
				trim_at = (int)i;
				break;
			} else {
				token_start = (token_start < 0) ? (int)i : token_start;
				if(delim.contains_char(x)) {
					if(token_start == i) {
						i++;
					}
					trim_at = (int)i;
					break;
				}
			}
		}
		if(token_start >= 0) {
			next.rebuild_and_copy_shallow(src);
			if(trim_at >= 0) {
				next.truncate(trim_at);
			}
			next.shift(token_start);
		} else {
			next.truncate();
		}
		src.shift((int)i);
		return 0;
	}

	public static int next_token_delimitered(extring*src, extring*next, extring*delim) {
		uint i = 0;
		int token_start = -1;
		int trim_at = -1;
		int len = src.length();
		for(i = 0; i < len; i++) {
			uchar x = src.char_at(i);
			token_start = (token_start < 0) ? (int)i : token_start;
			if(delim.contains_char(x)) {
				if(token_start == i) {
					i++;
				}
				trim_at = (int)i;
				break;
			}
		}
		if(token_start >= 0) {
			next.rebuild_and_copy_shallow(src);
			if(trim_at >= 0) {
				next.truncate(trim_at);
			}
			next.shift(token_start);
		} else {
			next.truncate();
		}
		src.shift((int)i);
		return 0;
	}


	public static int next_token_delimitered_sliteral(extring*src, extring*next, extring*delim, extring*wordDivider = null) {
		uint i = 0;
		int token_start = -1;
		int trim_at = -1;
		int len = src.length();
		bool stringLiteral = false;
		for(i = 0; i < len; i++) {
			uchar x = src.char_at(i);
			bool isQuote = (x == '\"');
			if((stringLiteral && isQuote) || ( !stringLiteral && ((wordDivider == null && (x == ' ' || x == '\r' || x == '\n' || isQuote)) || wordDivider.contains_char(x)) ) ) {
				if(token_start == -1) {
					if(isQuote) {
						stringLiteral = true;
						token_start = (int)i+1; // skip the quotation mark ..
					}
					continue;
				} else if(stringLiteral && isQuote) {
					trim_at = (int)i;
					i++; // skip the quotation mark ..
					break;
				}
				trim_at = (int)i;
				break;
			} else {
				token_start = (token_start < 0) ? (int)i : token_start;
				if(!stringLiteral && delim.contains_char(x)) {
					if(token_start == i) {
						i++; // this is one character token, it should contain only the delimiter
					}
					trim_at = (int)i;
					break;
				}
			}
		}
		if(token_start >= 0) {
			next.rebuild_and_copy_shallow(src);
			//(*next) = extring.share_estr(src);
			if(trim_at >= 0) {
				next.truncate(trim_at);
			}
			next.shift(token_start);
		} else {
			next.truncate();
			//(*next) = extring.EMPTY();
		}
		src.shift((int)i);
		return 0;
	}


	public static int next_token(extring*src, extring*next) {
		uint i = 0;
		int token_start = -1;
		int trim_at = -1;
		int len = src.length();
		for(i = 0; i < len; i++) {
			uchar x = src.char_at(i);
			if(x == ' ' || x == '\r' || x == '\n') {
				if(token_start == -1) {
					continue;
				}
				trim_at = (int)i;
				break;
			} else {
				token_start = (token_start < 0) ? (int)i : token_start;
			}
		}
		if(token_start >= 0) {
			next.rebuild_and_copy_shallow(src);
			//(*next) = extring.share_estr(src);
			if(trim_at >= 0) {
				next.truncate(trim_at);
			}
			next.shift(token_start);
		} else {
			next.truncate();
			//(*next) = extring.EMPTY();
		}
		src.shift((int)i);
		return 0;
	}

	public static int find_str(extring*src, extring*pattern){
		int src_length = src.length();
		int pattern_length = pattern.length();
		for(int i = 0; i <= (src_length - pattern_length); i++){
			int j = 0;
			for(j = 0; j < pattern_length && pattern.char_at(j) == src.char_at(i+j); j++);
			if(j >= pattern_length){
				return i;
			}
		}
		return -1;
	}
	
}
/** @}*/
