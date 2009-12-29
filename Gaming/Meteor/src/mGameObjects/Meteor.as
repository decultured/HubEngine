package mGameObjects
{
	import HubGaming.*;
	import HubGraphics.*;
	import HubInput.*;
	import flash.ui.*;
	
	public class Meteor extends hGameObject
	{
		private var _PowerupName:String = null;
				
		public function set PowerupName(powerupName:String):void {_PowerupName = powerupName;}
		public function get PowerupName():String {return _PowerupName;}
	
		public function Meteor()
		{
			super();
		}
	}
}