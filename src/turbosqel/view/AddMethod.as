package turbosqel.view {
	import com.bit101.components.ComboBox;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.VerticalWindow;
	import com.bit101.components.Window;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import turbosqel.events.ApplicationEvent;
	import turbosqel.events.GlobalDispatcher;
	import turbosqel.firefly.Align;
	import turbosqel.services.RemoteMethod;
	
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class AddMethod extends VerticalWindow {
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- PARAMS
		
		protected var method:RemoteMethod;
		
		protected var comboList:Array = new Array();
		
		public var nameField:InputText;
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- INIT
		
		public function AddMethod(parent:DisplayObjectContainer , toEdit:RemoteMethod = null) {
			method = toEdit;
			super(parent , { width:300 , height:200 , horizontalPosition:0 , verticalPosition:0 , align:Align.CENTER }, "Add method" );
			hasCloseButton = true;
			
		};
		
		
		
		override protected function addChildren():void {
			super.addChildren();
			new Label(this, { } , "function name: (class.method)");
			nameField = new InputText(this,{left:20 , right:20}, method?method.name:"");
			
			addChildAt(new PushButton(null , {bottom:1 , right:11 , width:60},"accept",accept),numChildren-1);
			
			if (method && method.params.length >0 ) {
				for (var i:int ; i < method.params.length ; i++ ) {
					addCombo(method.params[i]);
				};
			};
			
			addCombo();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- SETUP && UTILS
		
		private function addCombo(value:String = null):void {
			var c:ComboBox = new ComboBox(this , { } , value || RemoteMethod.NONE , RemoteMethod.types);
			c.addEventListener(Event.SELECT , onSelectValue);
			comboList.push(c);
		};
		
		private function onSelectValue(e:Event):void {
			var index:int = comboList.indexOf(e.currentTarget);
			if ( index == comboList.length - 1) {
				if (e.currentTarget.selectedItem != RemoteMethod.NONE) {
					addCombo();
				}
				return;
			}
			if (e.currentTarget.selectedItem == RemoteMethod.NONE) {
				comboList.splice(index, 1);
				e.currentTarget.remove();
			}
		}
		
		
		private function accept(e:Event):void {
			var met:RemoteMethod = method || new RemoteMethod();
			met.name = nameField.text;
			met.params.length = 0;
			for (var i:int ; i < comboList.length -1 ; i++ ) {
				met.params.push(comboList[i].value);
			};
			if (method) {
				GlobalDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.METHOD_LIST_CHANGE ));
			} else {
				GlobalDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.ADD_METHOD , met ));
			};
			remove();
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- REMOVE
		
		override public function remove():void {
			super.remove();
			UArray.remove(comboList);
			comboList = null;
		}
		
	}

}