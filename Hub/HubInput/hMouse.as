package HubInput
{
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.geom.*;

	public class hMouse 
	{
		private var _Target:DisplayObject;

		private var _Position:Point = new Point(0,0);
		private var _LeftPressed:Boolean = false;
		private var _WheelChange:Number = 0;
		private var _MouseOver:Boolean = false;

		public function get MouseOver():Boolean {return _MouseOver;}
		public function get LeftButton():Boolean {return _LeftPressed;}
		public function get X():Number {return _Position.x;}
		public function get Y():Number {return _Position.y;}

		public function hMouse(target:DisplayObject) 
		{
			_Target = target;
			_Target.addEventListener(MouseEvent.MOUSE_DOWN, LeftDownEvent, false, 0, true); 
			_Target.addEventListener(MouseEvent.MOUSE_UP, LeftUpEvent, false, 0, true);

			_Target.addEventListener(MouseEvent.MOUSE_MOVE, MoveEvent, false, 0, true);
			_Target.addEventListener(MouseEvent.MOUSE_WHEEL, WheelEvent, false, 0, true);

			_Target.addEventListener(MouseEvent.MOUSE_OVER, MouseOverEvent, false, 0, true);
			_Target.addEventListener(MouseEvent.MOUSE_OUT, MouseOutEvent, false, 0, true);
		}

		public function Update():void
		{
		}

		private function LeftDownEvent(event:MouseEvent):void { _LeftPressed = true; }
		private function LeftUpEvent(event:MouseEvent):void { _LeftPressed = false; }

		private function MouseOverEvent(event:MouseEvent):void { _MouseOver = true; }
		private function MouseOutEvent(event:MouseEvent):void { _MouseOver = false; }

		private function MoveEvent(event:MouseEvent):void
		{
		    _Position.x = event.localX;
		    _Position.y = event.localY;
		}
		
		private function WheelEvent(event:MouseEvent):void
		{
			_WheelChange = event.delta;
		}
	}	
}