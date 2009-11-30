package HubInput
{
	import flash.display.DisplayObject;
	
	public class hGlobalInput 
	{
		static private var _MouseController:hMouse;
		static private var _KeyboardController:hKeyboard;
		
		static public function get Mouse():hMouse {return _MouseController;}
		static public function get Keyboard():hKeyboard {return _KeyboardController;}
		
		static public function Initialize(target:DisplayObject):void
		{
			if (!_MouseController)
				_MouseController = new hMouse(target); 
			if (!_KeyboardController)
				_KeyboardController = new hKeyboard(target); 
		}	
		
		static public function Update():void
		{
			if (_MouseController)
				_MouseController.Update(); 
			if (_KeyboardController)
				_KeyboardController.Update(); 
		}
	}	
}