package turbosqel.view {
	import com.bit101.components.Background;
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
	import turbosqel.firefly.ElementContainer;
	import turbosqel.services.ParamPair;
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
		public var infoField:Label;
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- INIT
		
		public function AddMethod(parent:DisplayObjectContainer , toEdit:RemoteMethod = null) {
			method = toEdit;
			super(parent , { width:420 , height:220 , horizontalPosition:0 , verticalPosition:0 , align:Align.CENTER }, "Add method" );
			hasCloseButton = true;
		};
		
		
		
		override protected function addChildren():void {
			super.addChildren();
			new Label(this, { } , "function name: (class.method)");
			nameField = new InputText(this,{left:20 , right:20}, method?method.name:"");
			
			addChildAt(new PushButton(null , {y:222 , right:11 , width:60},"accept",accept),numChildren-1);
			addChildAt(new Label(null , { id:"info" , y:222 , left:5 , right:120 } ),1);
			addChildAt(new Background(null , { y:220 , height:25 , width:420 } ), 0);
			
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
		
		private function addCombo(value:ParamPair = null):void {
			var cont:ElementContainer = new ElementContainer({left:0 , right:0 , parent:this , height:15});
			var c:ComboBox = new ComboBox(cont , { id:"type", y:5 , horizontalPosition:5 ,right:5 } , value ? value.type : RemoteMethod.NONE , RemoteMethod.types);
			c.addEventListener(Event.SELECT , onSelectValue);
			var t:InputText = new InputText(cont , {id:"name", y:6 , height:18 , left: 5 , horizontalPosition:-5 } , value ? value.name : "param" + comboList.length );
			comboList.push(cont);
		};
		
		private function onSelectValue(e:Event):void {
			trace("on select val");
			var index:int = comboList.indexOf(e.currentTarget.parent);
			if ( index == comboList.length - 1) {
				if (e.currentTarget.selectedItem != RemoteMethod.NONE) {
					addCombo();
				}
				return;
			}
			if (e.currentTarget.selectedItem == RemoteMethod.NONE) {
				comboList.splice(index, 1)[0].remove();
			}
		}
		
		
		private function accept(e:Event):void {
			if (!nameField.text) {
				getChildByID("info")["text"] = "write class.method name";
				return;
			}
			
			var met:RemoteMethod = method || new RemoteMethod();
			met.name = nameField.text;
			met.params.length = 0;
			for (var i:int ; i < comboList.length -1 ; i++ ) {
				met.params.push(new ParamPair( comboList[i].getChildByID("name").value,comboList[i].getChildByID("type").value));
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