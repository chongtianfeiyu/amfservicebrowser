package turbosqel.net {
	import flash.net.NetConnection;
	import turbosqel.services.Service;
	
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public interface IDiscovery {
		
		function call(nc:AMFServiceConnection):void;
		
		function resultCallback(onFinish:Function):void;
		
		function remove():void;
	}
	
}