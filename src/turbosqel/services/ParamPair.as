package turbosqel.services {
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class ParamPair implements IExternalizable {
		public var name:String;
		public var type:String;
		
		public function ParamPair(name:String ="",type:String="") {
			this.name = name;
			this.type = type;
		};
		
		
		
		public function toString():String {
			return "Param  " + name + ":" + type;
		}
		
		
		
		public function writeExternal(output:IDataOutput):void {
			output.writeShort(name.length);
			output.writeUTFBytes(name);
			output.writeShort(type.length);
			output.writeUTFBytes(type);
		}
		
		public function readExternal(input:IDataInput):void {
			name = input.readUTFBytes(input.readShort());
			type = input.readUTFBytes(input.readShort());
		}
		
	}

}