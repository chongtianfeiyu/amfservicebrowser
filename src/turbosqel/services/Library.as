package turbosqel.services {
	import com.bit101.components.Window;
	import turbosqel.global.LocalObject;
	
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class Library extends Window {
		
		
		// <------------------------------- NOT FINISHED
		
		
		
		
		
		
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- STATIC SETUP
		
		public static var items:Object = new Object();
		
		protected static const key:String = "items";
		
		public static function importLocal():void {
			try {
				var imported:Object = LocalObject.load(key)["ITEMS"];
				if (imported == null) {
					trace("items::no cookies");
					return;
				}
				
				for (var name:String in imported) {
					items[name] = imported[name];
				};
			} catch (e:Error) {
				trace("items corrupted");
				LocalObject.remove(key);
			}
		};
		
		
		public static function saveLocal():void {
			LocalObject.save(key,"ITEMS" , items);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- DISPLAY WINDOW
		
		public function Library() {
			super(null, {});
		}
		
	}

}