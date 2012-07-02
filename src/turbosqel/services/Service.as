package turbosqel.services {
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import turbosqel.net.AMFServiceConnection;
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class Service implements IExternalizable {
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- PARAMS
		
		/**
		 * display name
		 */
		public var name:String;
		/**
		 * url link to gateway
		 */
		public var link:String;
		/**
		 * true if service is working
		 */
		public var approved:Boolean;
		/**
		 * methods list
		 */
		public var methods:Array = new Array();
		
		public var connection:AMFServiceConnection;
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- INIT
		
		public function Service(name:String = "name",  link:String = "link") {
			this.name = name;
			this.link = link;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- SERIALIZATION
		
		public function writeExternal(output:IDataOutput):void {
			output.writeShort(name.length);
			output.writeUTFBytes(name);
			output.writeShort(link.length);
			output.writeUTFBytes(link);
			output.writeBoolean(approved);
			output.writeObject(methods);
		}
		
		public function readExternal(input:IDataInput):void {
			name = input.readUTFBytes(input.readShort());
			link = input.readUTFBytes(input.readShort());
			approved = input.readBoolean();
			methods = input.readObject();
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- UTILS
		
		public function toString():String {
			return name + " :: " + link
		}
		
	}

}