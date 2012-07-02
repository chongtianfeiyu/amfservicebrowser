package turbosqel.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class ApplicationEvent extends Event {
		
		/**
		 * refresh services list view
		 */
		public static const SERVICES_LIST_CHANGE:String = "ServiceListChange";
		
		/**
		 * open service display ; event.data must be choosen Service
		 */
		public static const SHOW_SERVICE:String = "ShowService";
		/**
		 * show main menu
		 */
		public static const SHOW_MENU:String = "ShowMainMenu";
		
		/**
		 * display popup ; event.data must be String to display in popup
		 */
		public static const POP_UP:String = "DisplayPopup";
		/**
		 * display text in local window ; event.data must be String
		 */
		public static const LOCAL_INFO:String = "LocalInfo";
		
		/**
		 * add new method to current service ; event.data must be RemoteMethod instance
		 */
		public static const ADD_METHOD:String = "addMethod";
		
		/**
		 * refresh method list view
		 */
		public static const METHOD_LIST_CHANGE:String = "MethodListChange";
		
		
		
		
		
		
		
		
		public var data:Object;
		public function ApplicationEvent(type:String , data:Object = null) { 
			super(type);
			this.data = data;
		} 
		
		public override function toString():String { 
			return formatToString("ApplicationEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}