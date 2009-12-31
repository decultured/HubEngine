package mGameStates 
{
	import HubGaming.*;
	import flash.display.BitmapData;
	import flash.geom.*;
	import flash.utils.*;
	import HubGraphics.*;
	import HubInput.*;
	import mGameUI.*;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.net.*;
	
	public class mGameOverState extends hGameState
	{
		private var _StartGame:Boolean = false;
		private var _MainMenu:Boolean = false;
		private var _Game:MeteorGame;
		public var _GameOver:mGameOver;
		
		public function mGameOverState(name:String)
		{
			super(name);
			_GameOver = new mGameOver();
		}
		
		public function set Game(game:MeteorGame):void {_Game = game;}
		
		private function StartGameEvent(event:MouseEvent):void { _StartGame = true; }
		private function MainMenuEvent(event:MouseEvent):void { _MainMenu = true; }

		public override function Start():void
		{
			_StartGame = false;
			_MainMenu = false;
			hGlobalGraphics.View.ViewImage.addChild(_GameOver);
			_GameOver.Score.text = "FINAL SCORE: " + _Game.Score;
			_GameOver.StartGameButton.addEventListener(MouseEvent.CLICK, StartGameEvent);
			_GameOver.MainMenuButton.addEventListener(MouseEvent.CLICK, MainMenuEvent);
			
			if(_Game.Score > 0) {
				var req:APIRequest = APIInterface.newRequest('POST', 'game/meteor/scores/', {score: _Game.Score});
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

			if (_StartGame) {
				_Game.NewGame();
				ChangeState("GameState");
			} else if (_MainMenu)
				ChangeState("MenuState");
		}
	}
}