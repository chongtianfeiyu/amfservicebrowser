package turbosqel.analizerVisual {
	import com.bit101.components.HScrollBar;
	import com.bit101.components.ScrollBar;
	import com.bit101.components.VScrollBar;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import turbosqel.analizer.Analize;
	import turbosqel.analizer.AnalizeEvent;
	import turbosqel.console.Console;
	import turbosqel.display.SpriteShape;
	
	/**
	 * @author Gerard Sławiński || turbosqel
	 * analize tree (pure as3 + bit101 components)
	 */
	 
	public dynamic class AnalizeTree extends Sprite {
		
		//////////////////////////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////////////////////
		
		//<------------------------------ PARAMS
		
		public var content:Sprite = new Sprite();
		protected var sc:VScrollBar;
		protected var vc:HScrollBar;
		protected var masker:SpriteShape = SpriteShape.rectangle();
		protected var background:SpriteShape = SpriteShape.rectangle(0,0,100,100,0xF1F1F1);
		
		//////////////////////////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////////////////////
		
		//<------------------------------ INIT
		
		public function AnalizeTree():void {
			//////////////////////////////////////////////
			/// content
			addChild(content);
			addChild(masker);
			content.mask = masker;
			
			//////////////////////////////////////////////
			/// scroll
			sc = new VScrollBar(this , {x:180 , y:0} , scroll);
			vc = new HScrollBar(this , {x:0 , y:180}, scroll);
			UObject.apply(sc, {width:20 , height:200 , autoHide:false , lineSize:10 , pageSize:1});
			sc.setSliderParams(0 , 1 , 0);
			vc.setSliderParams(0 , 1 , 0);
			sc.setThumbPercent(0.3);
			vc.setThumbPercent(0.3);
			addChild(sc);
			
			/// mouse interact
			addEventListener(MouseEvent.MOUSE_WHEEL , scrolled);
			//////////////////////////////////////////////
			/// background
			addChildAt(background , 0);
			
			//////////////////////////////////////////////
			/// replace
			resizeContent();
		};
		
		//////////////////////////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////////////////////
		
		//<------------------------------ ITEMS / ANALIZE
		
		
		
		protected var actual:Analize;
		/**
		 * set analize
		 */
		public function set analize(an:Analize):void {
			release();
			actual = an;
			actual.addEventListener(AnalizeEvent.INVALIDATE , UFunction.delegateEvent(draw),false,0,true);
			slots.push(new AnalizeItem(this ,null, actual.analize));
			draw();
		};
		
		public function get analize():Analize {
			return actual;
		};
		
		
		internal function show(item:AnalizeItem , redraw:Boolean = true):void {
			var add:Array = new Array();
			for (var i:int ; i < item.analize["children"].length; i++ ) {
				add.push(new AnalizeItem(this , item, item.analize["children"][i]));
			};
			slots.splice.apply(null , [item.id + 1, 0].concat(add));
			if(redraw){
				draw();
			};
		};
		
		internal function hide(item:AnalizeItem , redraw:Boolean = true):void {
			var depth:int = item.depth;
			for (var i:int = item.id + 1 ; i < slots.length ; i ++ ) {
				if (slots[i].depth <= depth) {
					break;
				};
			};
			UArray.executeAndRemove(slots.splice(item.id +1 , i - item.id -1),"remove");
			if(redraw){
				draw();
			};
		};
		
		
		protected var slots:UArray = new UArray();
		
		public function draw():void {
			for (var i:int ; i < slots.length ; i++ ) {
				if (slots[i].invalidate()) {
					slots[i].y = 25 * i;
					slots[i].id = i;
					content.addChild(slots[i]);
				}else{
					slots.splice(i, 1);
					i--;
				};
			};
			resizeContent();
		};
		
		
		
		
		
		//////////////////////////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////////////////////
		
		//<------------------------------ SIZE && SCROLL
		
		//<--------- SCROLL
		
		protected function scrolled(e:MouseEvent):void {
			if(sc.enabled){
				sc.value -= e.delta / content.height * 10 ;
				scroll();
			};
		};
		
		public function scroll(e:Event = null):void {
			content.x = - vc.value * (content.width - masker.width + 10);
			content.y = - sc.value * (content.height - masker.height + 10);
		};
		
		
		
		
		
		//<--------- SIZE
		
		override public function get height():Number {
			return background.height;
		};
		
		override public function set height(value:Number):void {
			masker.height = value - vc.height;
			sc.height = value;
			vc.y = value - vc.height;
			background.height = value;
			resizeContent();
		};
		
		override public function get width():Number {
			return background.width;
		};
		
		override public function set width(value:Number):void {
			masker.width = value - sc.width;
			sc.x = value;
			vc.width = value - sc.width;
			background.width = value;
			resizeContent();
		};
		
		//<--------- REPLACE
		
		public function resizeContent():void {
			if (content.width > masker.width) {
				vc.enabled = true;
				scroll();
			} else {
				vc.enabled = false;
				content.x = 0;
			};
			if (content.height > masker.height) {
				sc.enabled = true;
				scroll();
			} else {
				sc.enabled = false;
				content.y = 0;
			};
		};
		
		//////////////////////////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////////////////////
		
		//<------------------------------ REMOVE / RELEASE
		
		public function release():void {
			if(slots){
				UArray.executeAndRemove(slots , "remove");
			};
			if (actual) {
				actual.remove();
				actual = null;
			};
		};
		
		public function remove():void {
			release();
			UDisplay.remove(this);
		};
		
		
		
	}

}