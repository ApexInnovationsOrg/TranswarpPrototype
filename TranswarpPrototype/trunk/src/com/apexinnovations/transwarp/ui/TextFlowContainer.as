package com.apexinnovations.transwarp.ui {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.InlineGraphicElementStatus;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.events.CompositionCompleteEvent;
	import flashx.textLayout.events.StatusChangeEvent;
	import flashx.textLayout.events.UpdateCompleteEvent;
	
	
	public class TextFlowContainer extends Component{

		public static const TEXT_FLOW_CONTAINER_UPDATE:String = "textflowcontainerupdate";
		
		protected var oldmarkup:XML;
		
		protected var _textFlow:TextFlow;
		protected var controller:ContainerController;
		
		protected var _maxWidth:Number = 400;
		protected var _maxHeight:Number = NaN;

		public function get textFlow():TextFlow { return _textFlow; }
		public function get textFlowMarkup():XML { return XML(TextConverter.export(_textFlow, TextConverter.TEXT_LAYOUT_FORMAT, ConversionType.XML_TYPE)); }
		public function get htmlMarkup():XML { return XML(TextConverter.export(_textFlow, TextConverter.TEXT_FIELD_HTML_FORMAT, ConversionType.XML_TYPE)); }
				
		public function get maxWidth():Number { return _maxWidth; }
		public function get maxHeight():Number { return _maxHeight; }
		
		public function setMaxSize(w:Number, h:Number):void {
			_maxWidth = w;
			_maxHeight = h;
			update();
		} 
		
		
		public function TextFlowContainer(text:Object = null) {
			super();

			setText(text);
			updateController();
		}

		public function setText(markup:Object):Boolean {
			removeOldFlow();

			if (markup is String)
				importXML(new XML(markup));
			else if (markup is XML)
				importXML(XML(markup));
			else if (markup is TextFlow)
				_textFlow = TextFlow(markup);
			
			if (_textFlow) {
				updateController();
				update();
				return true;
			} else
				return false;
		}
		
		protected function importXML(markup:XML):void {
			if(markup.localName() == null)
				markup = (<div />).appendChild(markup);
			
			if(markup == oldmarkup)
				return;
			
			oldmarkup = markup;
			
			_textFlow = TextConverter.importToFlow(markup, inferMarkupType(markup));
			setupListeners();
		}
		
		protected function setupListeners():void {
			if(!_textFlow) return;
			_textFlow.addEventListener(StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE, inlineGraphicsUpdate, false, 0, true);
			_textFlow.addEventListener(UpdateCompleteEvent.UPDATE_COMPLETE, broadcastUpdate, false, 0, true);
			_textFlow.addEventListener(CompositionCompleteEvent.COMPOSITION_COMPLETE, broadcastUpdate, false, 0, true);
		}
		
		protected function broadcastUpdate(e:Event):void {
			if(hasEventListener(TEXT_FLOW_CONTAINER_UPDATE))
				dispatchEvent(new Event(TEXT_FLOW_CONTAINER_UPDATE));
		}
		
		protected function inlineGraphicsUpdate(e:StatusChangeEvent):void {
			if(e.status == InlineGraphicElementStatus.READY || e.status == InlineGraphicElementStatus.SIZE_PENDING)
				update();
		}
		
		protected function update(e:Event = null):void {
			if (!_textFlow)
				return;
			controller.setCompositionSize(_maxWidth, _maxHeight);
			_textFlow.flowComposer.updateAllControllers();
		}

		protected function inferMarkupType(markup:XML):String {
			if (markup.localName() == "TextFlow")
				return TextConverter.TEXT_LAYOUT_FORMAT;
			else
				return TextConverter.TEXT_FIELD_HTML_FORMAT;
		}

		protected function updateController():void {
			if (!_textFlow)
				return;
			controller = new ContainerController(this, _maxWidth, _maxHeight)
			_textFlow.flowComposer.addController(controller);
			_textFlow.flowComposer.updateAllControllers();
			invalidate();
		}

		protected function removeOldFlow():void {
			if (!_textFlow)
				return;
			_textFlow.flowComposer.removeAllControllers();
		}
	}
}