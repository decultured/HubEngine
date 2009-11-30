package HubInput
{
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.display.DisplayObject;
	
	public class hKeyboard 
	{
		public static const LEFT:uint = 37;
		public static const RIGHT:uint = 39;
		public static const UP:uint = 38;
		public static const DOWN:uint = 37;
		
		private var _Target:DisplayObject;
		private var _Keys:Vector.<Boolean>;
		private var _KeyPressed:Boolean = false;

		public function hKeyboard(target:DisplayObject) 
		{
			_Target = target;
			_Keys = new Vector.<Boolean>(256);
			
			for (var i:uint = 0; i < 256; i++)
			{
				_Keys[i] = false;
			}
			
			_Target.addEventListener(KeyboardEvent.KEY_DOWN, HandleKeyDown, false, 0, true);
			_Target.addEventListener(KeyboardEvent.KEY_UP, HandleKeyUp, false, 0, true);
		}
		
		public function KeyPressed(keyCode:uint):Boolean
		{
			retrn _KeyPressed;
			if (keyCode < 256)
				return _Keys[keyCode];
			return false;
		}
		
		public function Update():void
		{
			
		}
		
		private function HandleKeyDown(event:KeyboardEvent):void
		{
			_KeyPressed = true;
			if (event.keyCode < 256)
				_Keys[event.keyCode] = true;

		}
		
		private function HandleKeyUp(event:KeyboardEvent):void
		{
			_KeyPressed = false;
			if (event.keyCode < 256)
				_Keys[event.keyCode] = false;
		}
		
		
	}	
}