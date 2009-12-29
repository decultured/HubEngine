package abGameStates 
{
	import HubGaming.*;
	import flash.display.BitmapData;
	import flash.geom.*;
	import flash.utils.*;
	import HubGraphics.*;
	import HubInput.*;
	import abGameUI.*;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.net.*;
	
	public class abGameOverState extends hGameState
	{
		private var _Game:AerobloxGame;
		public var _GameOver:abGameOver;
		
		public function abGameOverState(name:String)
		{
			super(name);
			_GameOver = new abGameOver();
		}
		
		public function set Game(game:AerobloxGame):void {_Game = game;}
		
		private function StartGameEvent(event:MouseEvent):void
		{
			_Game.NewGame();
			ChangeState("GameState");
		}
		private function MainMenuEvent(event:MouseEvent):void
		{ 
			_Game.NewGame();
			ChangeState("MenuState");
		}

		public override function Start():void
		{
			hGlobalGraphics.View.ViewImage.addChild(_GameOver);
			_GameOver.Score.text = "Final Score: " + _Game.Score;
			_GameOver.StartGameButton.addEventListener(MouseEvent.CLICK, StartGameEvent);
			_GameOver.MainMenuButton.addEventListener(MouseEvent.CLICK, MainMenuEvent);
			
			if(_Game.Score > 0) {
				var req:APIRequest = APIInterface.newRequest('POST', 'game/aeroblox/scores/', {score: _Game.Score});
				req.sendRequest();
			}
		}
		
		public override function Stop():void
		{
			hGlobalGraphics.View.ViewImage.removeChild(_GameOver);
			_GameOver.StartGameButton.removeEventListener(MouseEvent.CLICK, StartGameEvent);
			_GameOver.MainMenuButton.removeEventListener(MouseEvent.CLICK, MainMenuEvent);
		}
		
		public override function Run(elapsedTime:Number):void
		{
			hGlobalInput.Update();
		}
	}
}