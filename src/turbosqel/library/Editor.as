package turbosqel.library {
	import com.bit101.components.InputText;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.SwitchButton;
	import com.bit101.components.TextArea;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import turbosqel.analizer.Analize;
	import turbosqel.analizerVisual.AnalizeTree;
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class Editor extends Panel {
		
		
		
		public static const TREE_VIEW:String = "treeview";
		public static const JSON_STRING:String = "json";
		
		protected var applyJSON:PushButton;
		protected var switcher:SwitchButton;
		protected var analize:AnalizeTree;
		protected var json:TextArea;
		protected var info:InputText;
		
		
		public function Editor() {
			analize = new AnalizeTree();
			json = new TextArea(null , { top:25 , bottom:20 , left:0 , right:0 } );
			super();
			analize.y = 20;
			addChild(analize);
		};
		
		override protected function addChildren():void {
			super.addChildren();
			switcher = new SwitchButton(null , { x:0 , y:0 } , [JSON_STRING, TREE_VIEW]);
			switcher.addEventListener(MouseEvent.CLICK , onEditorChange);
			addChildAt(switcher, numChildren - 1);
			applyJSON = new PushButton(null, { left:0 , bottom:0 } , "Apply changes" , onApply);
			info = new InputText(null , {bottom:0 , left:100 ,right:0});
		}
		
		public function onApply(e:Event):void {
			try {
				var instance:Object = JSON.parse(json.text);
			}catch (e:Error) {
				info.text = "ParseError:"+e.message;
				return;
			}
			trace("set new value:" , instance);
			_target.value = instance;
		}
		
		private function onEditorChange(e:MouseEvent):void {
			mode = switcher.label;
		}
		
		
		
		protected var _target:LibraryItem;
		public function set value(target:LibraryItem):void {
			_target = target;
			analize.analize = Analize.parse(target.name , target.value);
		}
		
		override public function get value():*{
			return _target;
		}
		
		protected var _mode:String = JSON_STRING;
		public function set mode(type:String):void {
			if (type == _mode) {
				return;
			};
			content.removeElements(false);
			if (type != JSON_STRING) {
				addChild(json);
				addChild(applyJSON);
				addChild(info);
				try {
					json.text = JSON.stringify(_target.value);
				} catch (e:Error) {
					json.text = "parser error";
				}
			} else {
				analize.analize = Analize.parse(_target.name , _target.value);
				addChild(analize);
			};
			_mode = type;
			replaceElement();
		};
		
		
		
		
		
		
		
		override public function replaceElement():void {
			super.replaceElement();
			analize.width = this.width;
			analize.height = this.height;
		};
		
		
	}

}