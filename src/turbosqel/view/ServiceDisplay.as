package turbosqel.view {
	import com.bit101.components.Label;
	import com.bit101.components.List;
	import com.bit101.components.PushButton;
	import com.bit101.components.Text;
	import com.bit101.components.VBox;
	import flash.events.Event;
	import flash.net.Responder;
	import flash.text.TextFieldType;
	import turbosqel.analizer.Analize;
	import turbosqel.analizerVisual.AnalizeTree;
	import turbosqel.console.Console;
	import turbosqel.Data;
	import turbosqel.data.LVar;
	import turbosqel.events.ApplicationEvent;
	import turbosqel.events.DynamicEvent;
	import turbosqel.events.GlobalDispatcher;
	import turbosqel.firefly.ElementContainer;
	import turbosqel.library.Library;
	import turbosqel.library.LibraryItem;
	import turbosqel.net.AMFServiceConnection;
	import turbosqel.services.RemoteMethod;
	import turbosqel.services.Service;
	
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class ServiceDisplay extends ElementContainer {
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- DISPLAY COMPONENTS
		
		/**
		 * head ; service name
		 */
		protected var head:PushButton;
		/**
		 * remote method parameters generator
		 */
		protected var paramsBox:ParamsBox;
		/**
		 * function caller
		 */
		protected var caller:PushButton;
		
		/**
		 * remote methods list
		 */
		protected var list:List;
		
		/**
		 * output information text
		 */
		protected var infoText:Text;
		
		/**
		 * result analize
		 */
		protected var analizeTree:AnalizeTree;
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- INIT
		
		public function ServiceDisplay() {
			///////////////////////////////////////////////
			// setup
			super( { top:0 , left:0 , right:0 , bottom:0 } );
			///////////////////////////////////////////////
			// <-------- UI::
			// top: (info + save button)
			head = new PushButton(this, { top:0 , left:0 , right:200 , height:30 , enabled:false } );
			// save methods to lso
			new PushButton(this , { right:100 , top:0 , height:30 }, "Save local", UFunction.delegateEvent(Data.saveLocal));
			new PushButton(this , { right:200 , top:0 , height:30 }, "Export service", UFunction.delegateDynamicParams(Data.exportSingleService, new LVar(this , "service") ));
			// back to menu
			new PushButton(this, { right:0 , top:0 , height:30, width:100 } , "back to menu" , backToMenu);
			///////////////////////////////////////////////
			// left: (items list + list settings)
			list = new List(this, { left:0 , top:50 , bottom:0 , relativeWidth:0.3 } );
			list.bind(this, "methodFocus");
			// add , edit and remove
			new PushButton(this , { left:0 , top:30 , relativeWidth:0.1 }, "Add", addNewFunction);
			new PushButton(this , { horizontalPosition:0.1 , horizontalRatio:true , top:30 , relativeWidth:0.1 }, "Edit", editFunction);
			new PushButton(this , { horizontalPosition:0.2 , horizontalRatio:true , top:30 , relativeWidth:0.1 }, "Remove", removeFunction);
			///////////////////////////////////////////////
			// bottom	info text
			infoText = new Text(this, { bottom:0 , horizontalPosition:0.3 , horizontalRatio:true , right:0 , height:25 } , "ready");
			infoText.editable = false;
			infoText.textField.multiline = false;
			///////////////////////////////////////////////
			// center : params box , call method , library
			paramsBox = new ParamsBox(this , {top:30 , right:0 , horizontalPosition:0.3 , horizontalRatio:true , verticalPosition:-50});
			caller = new PushButton(this , { top:30 , right:0 ,verticalPosition:-70, enabled:false } , "call function", callRemoteMethod);
			new PushButton(this , { verticalPosition:-70 , right:0 , height:20 } , "save object" , exportObject );
			new PushButton(this , { verticalPosition:-90 , right:0 , height:20 }, "library", UFunction.delegateEvent(Library.show));
			///////////////////////////////////////////////
			// analize
			analizeTree = new AnalizeTree();
			addChild(analizeTree);
			
			
			///////////////////////////////////////////////
			// global events
			GlobalDispatcher.addEventListener(ApplicationEvent.ADD_METHOD, newFunction);
			GlobalDispatcher.addEventListener(ApplicationEvent.METHOD_LIST_CHANGE , refreshList);
			GlobalDispatcher.addEventListener(ApplicationEvent.LOCAL_INFO , displayInfo);
		};
		
		public function exportObject(e:Event):void {
			if (service && analizeTree.analize) {
				var item:LibraryItem = new LibraryItem(Library.getFreeName(service.name + ":"), analizeTree.analize.target);
				Library.add(item);
				if (isSimple(item.value)) {
					GlobalDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.SHOW_LIBRARY));
				} else {
					GlobalDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.EDIT_OBJECT , item));
				}
			}
		}
		
		
		private function isSimple(value:*):Boolean {
			if (value is Boolean || value is String || value is Number || value is int) {
				return true;
			}
			return false;
		}
		
		
		override public function replaceElement():void {
			super.replaceElement();
			// replace analize visual tree
			analizeTree.x = width * 3/10;
			analizeTree.width = width - analizeTree.x;
			analizeTree.y = height / 2 -50;
			analizeTree.height = height / 2 + 20;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- CALLING METHODS
		
		/**
		 * main responder
		 */
		protected var responder:Responder = new Responder(result , fault);
		
		/**
		 * call choosen method
		 * @param	e		event
		 */
		public function callRemoteMethod(e:Event):void {
			Console.Info("callRemoteMethod:",currentMethod.name);
			if (!currentMethod) {
				return;
			}
			var params:Array = paramsBox.getParams();
			GlobalDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.LOCAL_INFO , "calling method "+ currentMethod.name+ " with " + params.length + " parameters ..."));
			service.connection.nc.call.apply(null, [currentMethod.name , responder ].concat( params ));
		};
		
		/**
		 * net connection result
		 * @param	obj
		 */
		public function result(obj:Object):void {
			analizeTree.analize = Analize.parse("result" , obj);
			Console.Info("result:"+ UObject.toInfo(obj));
			GlobalDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.LOCAL_INFO , "server return call result"));
		}
		
		/**
		 * net connection fault
		 * @param	obj
		 */
		public function fault(obj:Object):void {
			analizeTree.analize = Analize.parse("fault" , obj);
			GlobalDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.LOCAL_INFO , "server return error : "+ UObject.toInfo(obj)));
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- DISPLAY SETTINGS
		
		/**
		 * close service display and back to menu
		 * @param	... args
		 */
		private function backToMenu(... args):void {
			GlobalDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.SHOW_MENU));
		}
		
		/**
		 * refresh methods list
		 * @param	e		any ...
		 */
		private function refreshList(e:ApplicationEvent = null):void {
			list.items = service.methods;
			list.deselect();
		}
		
		/**
		 * add new function to method list
		 * @param	e		application event with RemoteMethod in e.data parameter
		 */
		private function newFunction(e:ApplicationEvent):void {
			service.methods.push(e.data);
			refreshList();
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- SERVICE HANDLING
		
		/**
		 * current service
		 */
		public var service:Service;
		
		/**
		 * set current service
		 * @param	serv		service instance with amf connection
		 */
		public function content(serv:Service):void {
			service = serv;
			head.label = service.name;
			list.items = service.methods;
			methodFocus = null;
			refreshList();
			
			
			service.connection.addEventListener(AMFServiceConnection.INFO , displayServiceInfo);
			service.connection.addEventListener(AMFServiceConnection.ERROR , displayError);
		};
		
		// <------------------------------- INFORMATIONS ::
		
		/**
		 * display connection state
		 * @param	e
		 */
		private function displayServiceInfo(e:DynamicEvent):void {
			switch(e.text) {
				case "NetConnection.Call.BadVersion" :
					infoText.text = e.text + " :: remote function might have invalid arguments";
					return
				default : 
					infoText.text = e.text;
					
			}
			
		}
		
		/**
		 * display connection error
		 * @param	e
		 */
		private function displayError(e:DynamicEvent):void {
			infoText.text = e.text;
			GlobalDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.POP_UP , e.text));
		};
		
		/**
		 * display default information in bottom box
		 * @param	e
		 */
		private function displayInfo(e:ApplicationEvent):void {
			infoText.text = String(e.data);
		};
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- METHODS MANAGMENT
		
		/**
		 * new method window
		 * @param	e		event
		 */
		private function addNewFunction(e:Event):void {
			new AddMethod(this);
		}
		/**
		 * open method window and edit currently selected method
		 * @param	e		event
		 */
		private function editFunction(e:Event):void {
			new AddMethod(this , list.selectedItem as RemoteMethod);
		}
		/**
		 * remove selected function from service
		 * @param	e
		 */
		private function removeFunction(e:Event):void {
			UArray.searchAndSlice(service.methods , currentMethod);
			methodFocus = null;
			GlobalDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.METHOD_LIST_CHANGE));
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- METHODS
		
		/**
		 * currently selected method
		 */
		protected var currentMethod:RemoteMethod;
		
		
		/**
		 * focus on this method
		 */
		public function set methodFocus(met:RemoteMethod):void {
			currentMethod = met;
			paramsBox.value = currentMethod;
			
			caller.enabled = currentMethod ? true:false;
			paramsBox.enabled = currentMethod ? true:false;
			
		}
		
		
	}
	

}