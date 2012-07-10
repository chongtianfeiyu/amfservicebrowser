package turbosqel.net {
	import flash.events.AsyncErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import turbosqel.console.Console;
	import turbosqel.events.DynamicEvent;
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class AMFServiceConnection extends EventDispatcher {
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- EVENTS TYPES
		
		public static const COMPLETE:String = "Complete";
		public static const INFO:String = "Info";
		public static const ERROR:String = "Error";
		
		public static const DISCOVERY:String = "discoveryComplete";
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- INIT
		
		public var nc:NetConnection = new NetConnection();
		public function AMFServiceConnection():void {
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- FUNCTIONS
		
		/**
		 * connect to target url
		 * @param	link		gateway url
		 * @return				true if url is valid
		 */
		public function connect(link:String):Boolean {
			try {
				nc.connect(link);
				nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR , onAsyncError);
				nc.addEventListener(IOErrorEvent.IO_ERROR , onIOError);
				nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR , onSecurity);
				nc.addEventListener(NetStatusEvent.NET_STATUS , onStatus);
				return true;
			} catch (e:Error) {  };
			return false;
		}
		
		/**
		 * close and remove NetConnection
		 */
		public function remove():void {
			nc.close();
			nc.removeEventListener(AsyncErrorEvent.ASYNC_ERROR , onAsyncError);
			nc.removeEventListener(IOErrorEvent.IO_ERROR , onIOError);
			nc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR , onSecurity);
			nc.removeEventListener(NetStatusEvent.NET_STATUS , onStatus);
			nc = null;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- HANDLERS
		
		private function onStatus(e:NetStatusEvent):void {
			Console.Info("onStatus:",e.info.code);
			dispatchEvent(new DynamicEvent(INFO, {text:e.info.code}));
		}
		
		private function onSecurity(e:SecurityErrorEvent):void {
			Console.Info("onSecurity:",e.text);
			dispatchEvent(new DynamicEvent(ERROR, {text:e.text}));
		}
		
		private function onIOError(e:IOErrorEvent):void {
			Console.Info("onIOError:",e.text);
			dispatchEvent(new DynamicEvent(ERROR, {text:e.text}));
		}
		
		private function onAsyncError(e:AsyncErrorEvent):void {
			Console.Info("onAsyncError:",e.text);
			dispatchEvent(new DynamicEvent(ERROR, {text:e.text}));
		};
		
		
		
		
		
	}

}