using aroop;

/** \addtogroup make100
 *  @{
 */
public class shotodol.M100Variable: Searchable {
	public int intval;
	public xtring?strval;
	public enum ValueType {
		TEXT = 1,INT,ARRAY,POINTER
	}
	public ValueType tp;
	public M100Variable() {
		intval = 0;
		strval = null;
		tp = ValueType.INT;
	}
	public void concat(extring*dst) {
		if(tp == ValueType.INT) {
			extring output = extring.stack(32);
			output.printf("%d", intval);
			dst.concat(&output);
		} else if(tp == ValueType.TEXT) {
			if(strval != null)dst.concat((extring*)strval);
		}
	}
	public void set(extring*src) {
		bool isInt = true;
		int initialZeroes = 0;
		bool valueStarted = false;
		if(src.is_empty_magical()) {
			intval = 0;
			strval = null;
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
			strval = null;
			tp = ValueType.INT;
		} else {
			strval = new xtring.copy_on_demand(src);
			intval = decimalval;
			tp = ValueType.TEXT;
		}
	}
	public void setBool(bool val) {
		intval = val?1:0;
		tp = ValueType.INT;
	}
	public void setInt(int val) {
		intval = val;
		tp = ValueType.INT;
	}
}

/** @}*/
