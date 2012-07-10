package turbosqel.library {
	import com.bit101.components.Background;
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.system.System;
	import flash.text.TextFieldType;
	import turbosqel.events.ApplicationEvent;
	import turbosqel.events.GlobalDispatcher;
	import turbosqel.firefly.Element;
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class VisualItem extends Background {
		
		public var nameField:InputText;
		public var valueField:InputText;
		public var type:InputText;
		public var copy:PushButton;
		public var edit:PushButton;
		public var del:PushButton;
		
		public var target:LibraryItem;
		
		public function VisualItem(parent:DisplayObjectContainer , params:Object, item:LibraryItem) {
			this.target = item;
			super(parent,params);
		};
		override protected function addChildren():void {
			super.addChildren();
			nameField = new InputText(this, { y:2.5,relativeWidth:1/4 });
			nameField.bind(target , "name" , true);
			
			if (target.value is Number || target.value is String || target.value is int) {
				var simple:Boolean = true;
			} else {
				simple = false;
			};
			
			
			type = new InputText(this , {y:2.5, relativeWidth:1/4 , horizontalPosition:1/4 , horizontalRatio:true } ,target.value !=null ? target.value.constructor.toString():"null");
			type.textField.type = TextFieldType.DYNAMIC;
			valueField = new InputText(this , {y:2.5, relativeWidth:1/4 , horizontalPosition:1/2 , horizontalRatio:true} , String(target.value).substr(0, 40));
			if (!simple) {
				valueField.textField.type = TextFieldType.DYNAMIC;
			} else {
				valueField.type = target.value is int ? InputText.INTS : ((target.value is Number) ? InputText.NUMBERS : InputText.NORMAL);
				valueField.bind(target,"value");
			};
			
			
			copy = new PushButton(this, {relativeWidth:1/12 , horizontalPosition:3/4 , horizontalRatio:true},"copy", callFocus);
			edit = new PushButton(this , {relativeWidth:1/12 , horizontalPosition:10/12 , horizontalRatio:true , enabled:!simple},"edit",callEdit);
			del = new PushButton(this, { relativeWidth:1 / 12 , horizontalPosition:11 / 12 , horizontalRatio:true }, "del",callDelete);
		};
		
		public function callFocus(e:Event):void {
			Library.focus = target;
			System.setClipboard("$"+target.name);
		}
		
		private function callDelete(e:Event):void {
			Library.remove(target);
		}
		
		public function callEdit(e:Event):void {
			GlobalDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.EDIT_OBJECT , target));
		}
		
		override public function draw():void {
			super.draw();
		}
		
	}

}