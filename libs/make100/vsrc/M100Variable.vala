using aroop;

/** \addtogroup make100
 *  @{
 */
public class shotodol.M100Variable: Searchable {
	public int intval;
	public txt?txtval;
	public enum ValueType {
		TEXT = 1,INT,ARRAY,OBJECT
	}
	public ValueType tp;
	public M100Variable() {
		intval = 0;
		txtval = null;
		tp = ValueType.INT;
	}
	public void concat(etxt*dst) {
		if(tp == ValueType.INT) {
			etxt output = etxt.stack(32);
			output.printf("%d", intval);
			dst.concat(&output);
		} else if(tp == ValueType.TEXT) {
			if(txtval != null)dst.concat((etxt*)txtval);
		}
	}
	public void set(etxt*src) {
		bool isInt = true;
		int initialZeroes = 0;
		bool valueStarted = false;
		if(src.is_empty_magical()) {
			intval = 0;
			txtval = null;
			return;
		} 
		int len = src.length();
		int i = 0;
		for(i=0;i<len;i++) {
			uchar x = src.char_at(i);
			int decimal = x - '0';
			if(decimal == 0 && !valueStarted) {
				initialZeroes++;
			} else {
				valueStarted = true;
			}
			if(decimal > 9 || decimal < 0) {
				isInt = false;
				break;
			}
		}
		int decimalval = src.to_int();
		if(!(decimalval == 0 && initialZeroes == 1) && initialZeroes > 0) {
			isInt = false;
		}
		if(isInt) {
			intval = decimalval;
			txtval = null;
			tp = ValueType.INT;
		} else {
			txtval = new txt.memcopy_etxt(src);
			intval = decimalval;
			tp = ValueType.TEXT;
		}
	}
	public void setBool(bool val) {
		intval = val?1:0;
		tp = ValueType.INT;
	}
}

/** @}*/
