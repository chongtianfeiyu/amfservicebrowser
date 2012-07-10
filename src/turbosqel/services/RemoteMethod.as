package turbosqel.services {
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class RemoteMethod implements IExternalizable {// 
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- STATIC TYPES
		
		public static const NONE:String = "null";
		public static const STRING:String = "string";
		public static const INT:String = "int";
		public static const NUMBER:String = "number";
		public static const OBJECT:String = "object";
		public static const ARRAY:String = "array";
		
		public static const types:Array = [NONE , STRING , INT , NUMBER , OBJECT , ARRAY];
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- PARAMS && INIT
		
		/**
		 * display name
		 */
		public var name:String;
		/**
		 * remote function params
		 */
		public var params:Vector.<ParamPair> = new Vector.<ParamPair>();
		/**
		 * last typed parameters
		 */
		public var lastParams:Array = new Array();
		
		
		
		public function RemoteMethod() {
			
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- SERIALIZATION
		
		public function writeExternal(output:IDataOutput):void {
			output.writeShort(name.length);
			output.writeUTFBytes(name);
			output.writeObject(params);
			output.writeObject(lastParams);
		}
		
		public function readExternal(input:IDataInput):void {
			name = input.readUTFBytes(input.readShort());
			params = input.readObject();
			lastParams = input.readObject();
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- UTILS
		
		public function toString():String {
			var st:String = name + "( ";
			for (var i:int ; i < params.length ; i++) {
				st = st.concat(params[i].name + ":" + params[i].type + " ,");
			};
			return st.substr(0, st.length -1 ) + ")";
		}
		
	}

}