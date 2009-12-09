package HubInput
{
	import mx.core.UIComponent;
	import flash.events.*;
	
	public class hGlobalInput 
	{
		static private var _MouseController:hMouse;
		static private var _KeyboardController:hKeyboard;
		static private var _Target:UIComponent;
		static private var _ApplicationActive:Boolean = true;
		
		static public function get Mouse():hMouse {return _MouseController;}
		static public function get Keyboard():hKeyboard {return _KeyboardController;}
		static public function get ApplicationActive():Boolean {return _ApplicationActive;}

		static public function Initialize(target:UIComponent):void
		{
			_Target = target;
			if (!_MouseController)
				_MouseController = new hMouse(target); 
			if (!_KeyboardController)
				_KeyboardController = new hKeyboard(target); 
		}
		
		static public function ApplicationActivate(event:Event):void
		{
			_ApplicationActive = true;
		}
		
		static public function ApplicationDeactivate(event:Event):void
		{
			_ApplicationActive = false;
		}
		
		static public function GetFocus():void
		{
			_Target.setFocus();
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