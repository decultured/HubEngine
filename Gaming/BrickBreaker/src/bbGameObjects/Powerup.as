package bbGameObjects
{
	import HubGaming.*;
	import HubGraphics.*;
	import HubInput.*;
	import flash.ui.*;
	
	public class Powerup extends hGameObject
	{
		static private var _FallSpeed:Number = 100;
		
		private var _Type:String = null;
		  
		public function get Type():String {return _Type;}
		public function set Type(type:String):void {_Type = type;}
		
		public function Powerup()
		{
			super();
			ResetVelocity(0, _FallSpeed);
		}
		
		public override function Update(elapsedTime:Number):void
		{
			super.Update(elapsedTime);
		} 

		public override function Render():void
		{
			super.Render();
		}

	}
}