package turbosqel.net {
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import turbosqel.services.ParamPair;
	import turbosqel.services.RemoteMethod;
	import turbosqel.services.Service;
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class AmfphpDiscovery implements IDiscovery {
		
		protected var callback:Function;
		
		public function AmfphpDiscovery(onFinish:Function = null) {
			callback = onFinish;
		}
		
		
		public function call(service:AMFServiceConnection):void {
			service.nc.addEventListener(NetStatusEvent.NET_STATUS , statusEvent, false , 0 , true);
			service.nc.addEventListener(IOErrorEvent.IO_ERROR , eventFault, false , 0 , true);
			service.nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR , eventFault, false , 0 , true);
			service.nc.call("AmfphpDiscoveryService.discover" , new Responder(result,fault));
		};
		
		private function statusEvent(e:NetStatusEvent):void {
			trace("AmfphpDiscovery::statusEvent:",UObject.toInfo(e.info));
			if (e.info.code == "NetConnection.Call.Failed") {
				fault();
			}
		}
		
		private function eventFault(e:ErrorEvent):void {
			fault();
		}
		
		protected function result(res:Object):void {
			if (callback != null) {
				var items:Array = new Array();
				// to not duplicate:
				delete res["AmfphpDiscoveryService"];
				/////////////////////
				for each(var classes:Object in res) {
					var className:String = classes.name;
					for each(var method:Object in classes.methods) {
						var remote:RemoteMethod = new RemoteMethod();
						remote.name = className + "." + method.name;
						for (var i:int = 0; i < method.parameters.length ; i++) {
							var type:String = method.parameters[i].type;
							if (type == null || "param") {
								type = RemoteMethod.OBJECT;
							}
							remote.params.push(new ParamPair(method.parameters[i].name, type  ));
						};
						items.push(remote);
					};
				};
				callback(items);
			} else {
				trace("AmfphpDiscovery::result - warning - no callback function");
				traceStack();
			};
			remove();
		};
		
		protected function fault(fail:Object = null):void {
			if (callback != null) {
				callback(null);
			};
			remove();
		};
		
		public function resultCallback(onFinish:Function):void {
			callback = onFinish;
		}
		
		
		public function remove():void {
			callback = null;
		}
		
	}

}