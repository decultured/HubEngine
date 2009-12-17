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
		private var _StartGame:Boolean = false;
		private var _MainMenu:Boolean = false;
		private var _Game:AerobloxGame;
		public var _GameOver:abGameOver;
		
		public function abGameOverState() 
		{
			super();
			_GameOver = new abGameOver();
		}
		
		public function set Game(game:AerobloxGame):void {_Game = game;}
		
		private function StartGameEvent(event:MouseEvent):void { _StartGame = true; }
		private function MainMenuEvent(event:MouseEvent):void { _MainMenu = true; }

		public override function Start():void
		{
			_StartGame = false;
			_MainMenu = false;
			hGlobalGraphics.View.ViewImage.addChild(_GameOver);
			_GameOver.Score.text = "Final Score: " + _Game.Score;
			_GameOver.StartGameButton.addEventListener(MouseEvent.CLICK, StartGameEvent);
			_GameOver.MainMenuButton.addEventListener(MouseEvent.CLICK, MainMenuEvent);
			
			var postvar:URLVariables = new URLVariables();
			postvar.score = _Game.Score;
			
			var req:URLRequest = new URLRequest();
			req.url = 'http://onemorepoint.com/api/game/aeroblox/scores/';
			req.method = URLRequestMethod.POST;
			req.data = postvar;
			
			var reqload:URLLoader = new URLLoader();
			reqload.dataFormat = URLLoaderDataFormat.VARIABLES;
			try 
			{
				reqload.load(req);
			} 
			catch (error:Error) 
			{
				trace('Unable to load requested document.');
			}
		}
		
		public override function Stop():void
		{
			hGlobalGraphics.View.ViewImage.removeChild(_GameOver);
			_GameOver.StartGameButton.removeEventListener(MouseEvent.CLICK, StartGameEvent);
			_GameOver.MainMenuButton.removeEventListener(MouseEvent.CLICK, MainMenuEvent);
		}
		
		public override function Run(elapsedTime:Number):String
		{
			hGlobalInput.Update();

			if (_StartGame) {
				_Game.NewGame();
				return getQualifiedClassName(abGameState);
			} else if (_MainMenu)
				return getQualifiedClassName(abMenuState);
			return Name;
		}
	}
}