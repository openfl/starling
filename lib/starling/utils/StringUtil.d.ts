import EReg from "./../../EReg";
import Std from "./../../Std";
import HxOverrides from "./../../HxOverrides";

declare namespace starling.utils {

export class StringUtil {

	static format(format:any, args:any):any;
	static clean(string:any):any;
	static trimStart(string:any):any;
	static trimEnd(string:any):any;
	static trim(string:any):any;


}

}

export default starling.utils.StringUtil;