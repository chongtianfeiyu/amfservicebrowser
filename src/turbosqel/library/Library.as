package turbosqel.library {
	import com.bit101.components.ComboBox;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.VBox;
	import com.bit101.components.Window;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import turbosqel.AMFService;
	import turbosqel.events.ApplicationEvent;
	import turbosqel.events.GlobalDispatcher;
	import turbosqel.firefly.Align;
	import turbosqel.global.LocalObject;
	import turbosqel.services.RemoteMethod;
	
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class Library extends Window {
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- STATIC SETUP
		
		private static var lib:Library = new Library();
		
		public static function show():void {
			//if (items.length == 0) {
			//	items.push(new LibraryItem("defaultValue" , {x:100 , y:200}));
			//};
			AMFService.stage.addChild(lib);
		};
		
		
		public static var items:Vector.<LibraryItem> = new Vector.<LibraryItem>();
		
		public static var focus:LibraryItem;
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * add new item to list
		 * @param	item		library item
		 */
		public static function add(item:LibraryItem):void {
			if (items.indexOf(item) == -1) {
				items.push(item);
			};
			GlobalDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.INVALIDATE_LIBRARY));
		};
		
		public static function getItem(name:String):LibraryItem {
			for each(var item:LibraryItem in items) {
				if (item.name == name) {
					return item;
				}
			}
			return null;
		}
		
		public static function remove(item:LibraryItem):void {
			var index:int = items.indexOf(item);
			if (index != -1) {
				items.splice(index , 1);
			};
			GlobalDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.INVALIDATE_LIBRARY));
		};
		
		//protected static var offset:int;
		public static function getFreeName(offset:String = "local_"):String {
			var i:int = -1;
			var looking:Boolean = true;
			while (looking) {
				i++;
				looking = false;
				for each (var item:LibraryItem in items) {
					if (item.name == (offset + i.toString())) {
						looking = true;
						break;
					}
				}
				
			}
			return offset + i;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- LOCAL STOREAGE
		
		protected static const key:String = "items";
		
		public static function importLocal():void {
			try {
				var imported:Object = LocalObject.load(key)["ITEMS"];
				if (imported == null) {
					trace("items::no cookies");
					return;
				}
				
				for (var name:String in imported) {
					items[name] = imported[name];
				};
			} catch (e:Error) {
				trace("items corrupted");
				LocalObject.remove(key);
			}
		};
		
		
		public static function saveLocal():void {
			LocalObject.save(key,"ITEMS" , items);
		};
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- DISPLAY WINDOW
		
		protected var list:VBox;
		protected var editor:Editor;
		protected var backToList:PushButton;
		protected var newButton:PushButton;
		protected var newList:ComboBox;
		
		public function Library() {
			super(null, { width:550 , height:400 , hasCloseButton:true , horizontalPosition:0 , verticalPosition:0 , align:Align.CENTER } ,"Library");
			GlobalDispatcher.addEventListener(ApplicationEvent.EDIT_OBJECT , showEditor);
			GlobalDispatcher.addEventListener(ApplicationEvent.INVALIDATE_LIBRARY , UFunction.delegateEvent(refreshList));
			GlobalDispatcher.addEventListener(ApplicationEvent.SHOW_LIBRARY , showList);
			if (lib) {
				throw "singleton";
			};
		}
		
		override protected function addChildren():void {
			super.addChildren();
			list = new VBox(this, { top:25 , left:5 , bottom:5 , right:5 } );
			editor = new Editor();
			editor.applyPosition((content as Panel).getPosition());
			backToList = new PushButton(null , { right:0 , top:20 }, "back to list", showList);
			
			newButton = new PushButton(this, { top:0 , left:5 } , "Create:" , onCreate);
			newList = new ComboBox(this,{top:0 , left:105},"Object" , RemoteMethod.types);
		};
		
		public function onCreate(e:Event):void {
			var value:Object;
			switch(newList.selectedItem) {
				case RemoteMethod.NONE :
					value = null;
					break;
				case RemoteMethod.STRING :
					value = "";
					break;
				case RemoteMethod.INT :
					value = int(0);
					break;
				case RemoteMethod.NUMBER :
					value = Number(0);
					break;
				case RemoteMethod.ARRAY :
					value = [];
					break;
				case RemoteMethod.OBJECT :
					value = {};
					break;
			}
			Library.add(new LibraryItem(Library.getFreeName(), value));
		}
		
		override public function draw():void {
			super.draw();
			refreshList();
		};
		
		protected function refreshList(... args):void {
			list.removeElements(true);
			for (var i:int ; i < items.length ; i++ ) {
				list.addChild(new VisualItem(list , {left:2 , right:2 , height:20 , y:2} , items[i]));
			};    
		}
		
		
		
		
		
		
		public function showList(e:Event = null):void {
			if (editor.parent) {
				removeChild(editor);
				removeChild(backToList);
			};
			addChildAt(content , 0);
			show();
		}
		
		public function showEditor(e:ApplicationEvent):void {
			var item:LibraryItem = e.data as LibraryItem;
			trace("show editor");
			if (item) {
				if (content.parent) {
					removeChild(content);
				};
				addChildAt(editor, 0);
				addChildAt(backToList, 1);
				editor.value = item;
			}
			show();
		}
		
		
		
		
		
		
		
		
		
		
		
		
		override protected function onClose(event:MouseEvent):void {
			if(parent){
				parent.removeChild(this);
			}
		}
		
	}

}