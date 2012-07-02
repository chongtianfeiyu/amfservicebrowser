package turbosqel 
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import turbosqel.console.Console;
	import turbosqel.events.ApplicationEvent;
	import turbosqel.events.GlobalDispatcher;
	import turbosqel.global.LocalObject;
	import turbosqel.services.Service;
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class Data {
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- SERVICES :: ADD/REMOVE , LIST
		
		/**
		 * current services list
		 */
		public static var services:Array = new Array();
		
		
		
		
		/**
		 * add new service
		 * @param	name		display name
		 * @param	link		gateway url link
		 * @return				created or existing Service with same link
		 */
		public static function newService(name:String , link:String ):Service {
			var serv:Service = UArray.searchValues(services, "link" , link);
			if (!serv) {
				serv = new Service(name, link);
				services.push(serv);
				GlobalDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.SERVICES_LIST_CHANGE));
			};
			return serv;
		}
		
		/**
		 * remove service from list
		 * @param	service		target service
		 */
		public static function remove(service:Service):void {
			if (UArray.searchAndSlice(services, service)) {
				GlobalDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.SERVICES_LIST_CHANGE));
			};
		};
		
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- SAVE / LOAD LSO
		
		/**
		 * lso key
		 */
		protected static const key:String = "services";
		
		/**
		 * try import local saved services
		 */
		public static function importLocal():void {
			try {
				var imported:Array = LocalObject.load(key)["array"];
				if (imported == null) {
					trace("no cookies");
					return;
				}
				
				for each (var service:Service in imported) {
					if (!UArray.searchValues(services, "link" , service.link)) {
						services.push(service);
					};
				};
				GlobalDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.SERVICES_LIST_CHANGE));
			} catch (e:Error) {
				GlobalDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.POP_UP , "error loading services from memory"));
				LocalObject.remove(key);
			}
		};
		
		/**
		 * save to local storeage
		 */
		public static function saveLocal():void {
			LocalObject.save(key,"array" , services);
		}
		
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- SAVE / LOAD FILE
		
		/**
		 * open save window
		 * @param	... args		doesnt matter
		 */
		public static function exportFile(... args):void {
			var ba:ByteArray = new ByteArray();
			ba.writeObject(services);
			ba.compress();
			(new FileReference()).save(ba,"amfservices.amf3");
		};
		
		
		
		/**
		 * loading operation scope
		 */
		protected static var fr:FileReference;
		
		/**
		 * open browse window
		 * @param	... args		doesnt matter
		 */
		public static function importFile(... args):void {
			fr = new FileReference();
			fr.addEventListener(Event.SELECT , loadFile);
			fr.addEventListener(Event.COMPLETE , loadFileComplete);
			fr.addEventListener(IOErrorEvent.IO_ERROR , loadError);
			fr.addEventListener(SecurityErrorEvent.SECURITY_ERROR ,loadError);
			fr.browse();
		};
		
		/**
		 * load selected file
		 * @param	e		event
		 */
		static private function loadFile(e:Event):void {
			fr.load();
		}
		
		/**
		 * load complete , parse file
		 * @param	e		event
		 */
		static private function loadFileComplete(e:Event):void {
			parseBytes(fr.data);
			fr = null;
		};
		
		public static function parseBytes(bytes:ByteArray):void {
			try {
				bytes.uncompress();
				var items:Array = bytes.readObject();
				for each(var item:Service in items ) {
					services.push(item);
				}
				GlobalDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.SERVICES_LIST_CHANGE));
				GlobalDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.POP_UP , "loaded " + items.length + " items"));
			} catch (e:Error) {
				GlobalDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.POP_UP , "parse error:"+e.message));
			}
		}
		
		/**
		 * load file error
		 * @param	e		event
		 */
		static private function loadError(e:ErrorEvent):void {
			GlobalDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.POP_UP , "load error:"+e.text));
		}
		
		
	}

}