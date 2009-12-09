package HubInput
{
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import mx.core.UIComponent;
	import nl.demonsters.debugger.MonsterDebugger;
		
	public class hKeyboard 
	{
		private var _Target:UIComponent;
		private var _Keys:Array;

		public function hKeyboard(target:UIComponent) 
		{
			_Target = target;
			_Target.addEventListener(KeyboardEvent.KEY_DOWN, HandleKeyDown, false, 0, true);
			_Target.addEventListener(KeyboardEvent.KEY_UP, HandleKeyUp, false, 0, true);

			_Keys = new Array(256);
			for (var i:uint = 0; i < 256; i++)
			{
				_Keys[i] = 0;
			}
		}
		
		public function KeyPressed(keyCode:uint):Boolean
		{
			if (keyCode < 256 && _Keys[keyCode] > 0)
				return true;
			return false;
		}
		
		public function KeyJustPressed(keyCode:uint):Boolean
		{
			if (keyCode < 256 && _Keys[keyCode] == 2)
				return true;
			return false;
		}
		
		public function Update():void
		{
			for (var i:uint = 0; i < 256; i++)
			{
				if (_Keys[i] == 1)
					_Keys[i] = 2;
				else if (_Keys[i] == 2)
					_Keys[i] = 3;
			}
		}
		
		private function HandleKeyDown(event:KeyboardEvent):void
		{
			if (event.keyCode < 256 && _Keys[event.keyCode] == 0)
				_Keys[event.keyCode] = 1;
		}
		
		private function HandleKeyUp(event:KeyboardEvent):void
		{
			if (event.keyCode < 256)
				_Keys[event.keyCode] = 0;
		}
	}	
}