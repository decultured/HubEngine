package mGameObjects
{
	import HubGaming.*;
	import HubGraphics.*;
	import HubInput.*;
	import flash.ui.*;
	
	public class Meteor extends MeteorGameObject
	{
		private var _Shape:String = null;
		private var _PowerupName:String = null;
				
		public function set PowerupName(powerupName:String):void {_PowerupName = powerupName;}
		public function get PowerupName():String {return _PowerupName;}
		public function set Shape(shape:String):void {_Shape = shape;}
		public function get Shape():String {return _Shape;}
	
		public function Meteor()
		{
			super();
		}
	}
}