package turbosqel.library {
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class LibraryItem {
		
		public var name:String;
		public var value:Object;
		public var info:String;
		
		public function LibraryItem(name:String ="", value:Object ="", info:String = null )	{
			this.name = name;
			this.info = info;
			this.value = value;
		}
		
	}

}