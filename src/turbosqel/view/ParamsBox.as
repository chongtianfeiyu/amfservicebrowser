package turbosqel.view 
{
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.VBox;
	import flash.display.DisplayObjectContainer;
	import turbosqel.console.CommandClosure;
	import turbosqel.console.Console;
	import turbosqel.events.ApplicationEvent;
	import turbosqel.events.GlobalDispatcher;
	import turbosqel.services.RemoteMethod;
	
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class ParamsBox extends VBox {
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- INIT
		
		public function ParamsBox(parent:DisplayObjectContainer,params:Object) {
			super(parent, params);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <------------------------------- METHOD SCOPE
		
		/**
		 * current focus
		 */
		public var currentMethod:RemoteMethod;
		
		/**
		 * current parameters list
		 */
		protected var paramsList:Array = new Array();
		
		/**
		 * clear last list and create new input fields for method parameters
		 */
		public function set value(val:*):void  {
			currentMethod = val;
			removeElements(true);
			paramsList.length = 0;
			if (currentMethod) {
				for (var i:int ; i < currentMethod.params.length ; i++ ) {
					new Label(this, { x:30 }, currentMethod.params[i] + ":");
					paramsList.push(new InputText(this , { left:25 , right:150 } , currentMethod.lastParams[i] ?currentMethod.lastParams[i].toString():""));
				}
			}
		}
		
		/**
		 * return current selected parameters
		 * @return		selected parameters
		 */
		public function getParams():Array {
			var res:Array = new Array();
			for (var i:int ; i < paramsList.length ; i++ ) {
				if (paramsList[i].text.charAt(0) == "$") {
					// for library
				};
				switch(currentMethod.params[i]) {
					case RemoteMethod.NONE :
						var value:Object = null;
						break;
					case RemoteMethod.INT :
						value = int(paramsList[i].text);
						break;
					case RemoteMethod.NUMBER :
						value = Number(paramsList[i].text);
						break;
					case RemoteMethod.STRING :
						value = paramsList[i].text;
						break;
					case RemoteMethod.OBJECT :
					case RemoteMethod.ARRAY :
						Console.Info("json parse");
						try {
						value = JSON.parse(paramsList[i].text);
						} catch (e:Error) {
							
							var line:String = paramsList[i].text.length > 50 ? paramsList[i].text.substr(0, 50): paramsList[i].text;
							GlobalDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.POP_UP , "JSON parse error:"+e.message+ " on line:\n" + paramsList[i].text));
						}
						break;
				}
				currentMethod.lastParams[i] = paramsList[i].text;
				res[i] = value;
			}
			return res;
		};
		
	}

}