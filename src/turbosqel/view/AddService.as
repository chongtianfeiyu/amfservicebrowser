package turbosqel.view {
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Window;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import turbosqel.Data;
	import turbosqel.events.ApplicationEvent;
	import turbosqel.events.GlobalDispatcher;
	import turbosqel.firefly.Align;
	import turbosqel.net.AMFServiceConnection;
	import turbosqel.services.Service;
	
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class AddService extends Window {
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- DISPLAY ITEMS
		
		public var nameField:InputText;
		
		public var linkField:InputText;
		
		public var infoLabel:Label;
		
		protected var service:Service ;
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- INIT
		
		public function AddService(parent:DisplayObjectContainer , toEdit:Service = null) {
			////////////////////////////////
			// init setup
			this.service = toEdit;
			super(parent);
			title = "Add service";
			horizontalPosition = 0;
			verticalPosition = 0;
			align = Align.CENTER;
			width = 380;
			height = 200;
			draggable = true;
			hasCloseButton = true;
		}
		
		override protected function addChildren():void {
			super.addChildren();
			////////////////////////////////
			// add labels and input fields
			new Label(this , { left:30 , right:30, top:20 } , "service name:");
			nameField = new InputText(this , { left:30 , right:30, top:35 }, service?service.name : "");
			
			new Label(this , { left:30 , right:30, top:50 } , "gateway link:");
			linkField = new InputText(this , { left:30 , right:30, top:65 } , service?service.link : "" );
			
			////////////////////////////////
			// hidden info label
			infoLabel = new Label(this , { left:30 , right:30 , top:95 },  "");
			
			////////////////////////////////
			// apply button
			new PushButton(this , { bottom:15 , right:15 } , "Add" , confirm);
			
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- INTERNAL
		
		private function confirm(e:MouseEvent):void {
			////////////////////////////////
			// end link verification
			var conn:AMFServiceConnection = new AMFServiceConnection();
			if (!conn.connect(linkField.text)) {
				infoLabel.text = "invalid url address";
				return;
			};
			////////////////////////////////
			// check if edit or new
			if (service) {
				service.name = nameField.text;
				service.link = linkField.text;
				service.connection = conn;
				service = null;
				GlobalDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.SERVICES_LIST_CHANGE));
			} else {
				Data.newService(nameField.text , linkField.text).connection = conn;
			}
			////////////////////////////////
			// remove window
			remove();
		}
		
	}

}