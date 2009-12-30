package mGameObjects
{
	import HubGaming.*;
	import HubGraphics.*;
	import HubInput.*;
	import flash.ui.*;
	
	public class Projectile extends MeteorGameObject
	{
		private var _LifeSpan:Number = 0.8;
		private var _TimeAlive:Number = 0;
		private var _Type:String = null;
		  
		public function get Type():String {return _Type;}
		public function set Type(type:String):void {_Type = type;}
		
		public function Projectile()
		{
			super();
			CurrentAnimation = "projectile";
		}
		
		public override function Update(elapsedTime:Number):void
		{
			super.Update(elapsedTime);
			
			_TimeAlive += elapsedTime;
			
			if (_TimeAlive > _LifeSpan) {
				Active = false;
				Visible = false;
			}
		} 

		public override function Render():void
		{
			super.Render();
		}

	}
}