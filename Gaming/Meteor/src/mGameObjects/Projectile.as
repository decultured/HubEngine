package mGameObjects
{
	import HubGaming.*;
	import HubGraphics.*;
	import HubInput.*;
	import flash.ui.*;
	
	public class Projectile extends hGameObject
	{
		private var _Type:String = null;
		  
		public function get Type():String {return _Type;}
		public function set Type(type:String):void {_Type = type;}
		
		public function Projectile()
		{
			super();
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