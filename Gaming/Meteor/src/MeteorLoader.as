package  
{
	import HubGaming.*;
	import HubGraphics.*;
	import HubAudio.*;

	public class MeteorLoader extends hGameLoader
	{
		private var _Game:MeteorGame;

		public function get Game():MeteorGame {return _Game;}
		public function set Game(game:MeteorGame):void {_Game = game;}

		public function MeteorLoader()
		{
			super();
		}
		
		protected override function LoadData(hubGame:XML):void
		{
			super.LoadData(hubGame);
			
			if (!_Game)
				return;
			
/*			for each (var newMeteor:XML in hubGame..block) {
				_Game.AddMeteor(newMeteor["@image"], newMeteor["@shape"], Number(newMeteor["@x"]), Number(newMeteor["@y"]), Number(newMeteor["@width"]), Number(newMeteor["@height"]), uint(newMeteor["@start_frame"]), newMeteor["@powerup"]);
			}
			for each (var newProjectile:XML in hubGame..powerup) {
				_Game.AddProjectile(newProjectile["@image"], newProjectile["@type"], Number(newProjectile["@width"]), Number(newProjectile["@height"]), uint(newProjectile["@start_frame"]));
			}
			for each (var newShip:XML in hubGame..ball) {
				_Game.AddShip(newShip["@image"], Number(newShip["@width"]), Number(newShip["@height"]));
			}
			for each (var newBackground:XML in hubGame..background) {
				hGlobalGraphics.BackgroundImage = newBackground["@image"];
			}*/
		}
	}
}
