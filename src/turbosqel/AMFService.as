package turbosqel{
	import com.bit101.components.Label;
	import com.bit101.components.Window;
	import flash.events.Event;
	import turbosqel.console.ConsoleWindow;
	import turbosqel.data.resources.ResourceManage;
	import turbosqel.events.ApplicationEvent;
	import turbosqel.events.GlobalDispatcher;
	import turbosqel.firefly.Align;
	import turbosqel.firefly.FireCore;
	import turbosqel.net.Alias;
	import turbosqel.net.AMFServiceConnection;
	import turbosqel.net.bytes.URLoader;
	import turbosqel.services.RemoteMethod;
	import turbosqel.services.Service;
	import turbosqel.view.MainMenu;
	import turbosqel.view.ServiceDisplay;
	
	/**
	 * 
	 * 
	 * 
	 * 
	 * @author Gerard Sławiński || turbosqel
	 */
	public class AMFService extends FireCore {
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- DISPLAY ELEMENTS
		
		public var menu:MainMenu;
		public var display:ServiceDisplay;
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- INIT
		
		public function AMFService():void {
			super();
		};
		
		override protected function addedToStage(e:Event):void {
			super.addedToStage(e);
			ConsoleWindow.run(stage);
			////////////////////////////////////////////////
			////////////////////////////////////////////////
			// GLOBAL SETUP
			Alias.addClass(Service);
			Alias.addClass(RemoteMethod);
			///////////////////////////////////////////////
			// ELEMENTS
			menu = new MainMenu();
			display = new ServiceDisplay();
			GlobalDispatcher.addEventListener(ApplicationEvent.SHOW_MENU , showMenu);
			GlobalDispatcher.addEventListener(ApplicationEvent.SHOW_SERVICE , showService);
			GlobalDispatcher.addEventListener(ApplicationEvent.POP_UP , showPopup);
			///////////////////////////////////////////////
			// LOAD LOCAL DATA
			Data.importLocal();
			///////////////////
			/*
			if (Data.services.length == 0) {
				ResourceManage.getBridgeAndLoad("amfservices.amf3" , URLoader, Data.parseBytes);
			};*/
			///////////////////////////////////////////////
			// START APP
			showMenu();
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- DISPLAY FUNCTIONS
		
		// 3 options : main menu , service display and popup info
		//
		
		private function showPopup(e:ApplicationEvent):void {
			var win:Window = new Window(stage , { horizontalPosition:0 , verticalPosition:0 , width:400 , height:250 , align:Align.CENTER }, "Alert");
			win.addChild(new Label(null , { top:10 , left:10 , right:10 , bottom:10 }, String(e.data)) );
			win.hasCloseButton = true;
		}
		
		private function showMenu(e:ApplicationEvent = null):void {
			UDisplay.removeChildren(this);
			addChild(menu);
		}
		
		private function showService(e:ApplicationEvent):void {
			UDisplay.removeChildren(this);
			addChild(display);
			if (ser && ser.connection) {
				ser.connection.remove();
			}
			var ser:Service = e.data as Service;
			ser.connection = new AMFServiceConnection();
			ser.connection.connect(ser.link);
			display.content(ser);
		}
		
	}
	
}