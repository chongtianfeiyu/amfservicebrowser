package turbosqel.view {
	import com.bit101.components.List;
	import com.bit101.components.PushButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	import turbosqel.console.Console;
	import turbosqel.Data;
	import turbosqel.events.ApplicationEvent;
	import turbosqel.events.GlobalDispatcher;
	import turbosqel.firefly.Align;
	import turbosqel.firefly.ElementContainer;
	import turbosqel.library.Library;
	import turbosqel.services.Service;
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class MainMenu extends ElementContainer {
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- PARAMS
		
		
		// <------------------------------- COMPONENTS
		public var list:List;
		public var newService:PushButton;
		public var editService:PushButton;
		public var removeService:PushButton;
		public var saveService:PushButton;
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- INIT
		
		public function MainMenu() {
			////////////////////////////////
			// container setup
			super( { top:0 , left:0 , right:0 , bottom:0 } );
			
			////////////////////////////////
			// services list
			list = new List(this , { top:50 , left:50 , right:50 , bottom:150 , enabled:Data.services.length > 0 } , Data.services);
			list.bind(this , "target"); // select item
			////////////////////////////////
			// edit buttons
			newService = new PushButton(this , { horizontalPosition:0.2 , horizontalRatio:true, bottom:30, relativeWidth:0.2, height:100 } , "Add service" , addService);
			editService = new PushButton(this , { enabled:false, align:Align.TOP ,horizontalRatio:true, horizontalPosition:0.5, relativeWidth:0.2 , horizontalRatio:true , bottom:30 , height:100 }, "Edit service" , openEditService);
			removeService = new PushButton(this, {enabled:false, horizontalRatio:true, horizontalPosition:0.6 , relativeWidth:0.2 , bottom:30 , height:100}, "Remove service" , spliceService);
			////////////////////////////////////////////////////////////////
			////////////////////////////////////////////////////////////////
			// top menu
			new PushButton(this , { align:Align.BOTTOM_LEFT , right:350 , top:50 }, "Open library", UFunction.delegateEvent(Library.show));
			
			////////////////////////////////
			// save data to local store
			saveService = new PushButton(this ,{align:Align.BOTTOM_LEFT , right:50 , top:50},"Save",UFunction.delegateEvent(Data.saveLocal))
			////////////////////////////////
			// save/load file
			new PushButton(this , {align:Align.BOTTOM_LEFT , right:150 , top:50}, "Save to file", Data.exportFile);
			new PushButton(this , {align:Align.BOTTOM_LEFT , right:250 , top:50}, "Load from file", Data.importFile);
			////////////////////////////////
			// invalidate services list
			GlobalDispatcher.addEventListener(ApplicationEvent.SERVICES_LIST_CHANGE, onListChange);
			
		};
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- SERVICE UTILS :: REMOVE AND REFRESH LIST
		
		
		private function spliceService(e:Event):void {
			Data.remove(currentTarget);
		}
		
		private function onListChange(e:ApplicationEvent):void {
			list.deselect();
			list.items = Data.services;
			
			if (Data.services.length > 0) {
				list.enabled = true;
			};
		};
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- SERVICE ADD/EDIT WINDOW
		
		private function addService(e:MouseEvent):void {
			new AddService(this);
		}
		
		private function openEditService(e:Event):void {
			new AddService(this , currentTarget);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- SERVICE FOCUS
		
		protected var currentTarget:Service;
		
		public function set target(serv:*):void {
			if (serv && currentTarget == serv) {
				GlobalDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.SHOW_SERVICE , serv));
				return;
			}
			currentTarget = serv;
			if (serv) {
				editService.enabled = true;
				removeService.enabled = true;
			} else {
				editService.enabled = false;
				removeService.enabled = false;
			}
		};
		
		
	}

}