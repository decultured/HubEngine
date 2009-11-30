package HubInput
{
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import nl.demonsters.debugger.MonsterDebugger;
		
	public class hKeyboard 
	{
		public static const LEFT:uint = 37;
		public static const RIGHT:uint = 39;
		public static const UP:uint = 38;
		public static const DOWN:uint = 37;
		
		private var _Target:DisplayObject;
		private var _Keys:Array;
		private var _KeyPressed:Boolean = false;

		public function hKeyboard(target:DisplayObject) 
		{
			_Target = target;
			_Target.addEventListener(KeyboardEvent.KEY_DOWN, HandleKeyDown, false, 0, true);
			_Target.addEventListener(KeyboardEvent.KEY_UP, HandleKeyUp, false, 0, true);

			_Keys = new Array(256);
			for (var i:uint = 0; i < 256; i++)
			{
				_Keys[i] = false;
			}
		}
		
		public function KeyPressed(keyCode:uint):Boolean
		{
			if (keyCode < 256)
				return _Keys[keyCode];
			return false;
		}
		
		public function Update():void
		{
			
		}
		
		private function HandleKeyDown(event:KeyboardEvent):void
		{
			if (event.keyCode < 256)
				_Keys[event.keyCode] = true;
		}
		
		private function HandleKeyUp(event:KeyboardEvent):void
		{
			if (event.keyCode < 256)
				_Keys[event.keyCode] = false;
		}
		
		
	}	
}