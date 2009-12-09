package bbGameStates 
{
	import HubGaming.*;
	import flash.display.BitmapData;
	import flash.geom.*;
	import flash.utils.*;
	import HubGraphics.*;
	import HubInput.*;
	import bbGameUI.*;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class bbGameOverState extends hGameState
	{
		private var _StartGame:Boolean = false;
		private var _MainMenu:Boolean = false;
		private var _Game:BrickBreakerGame;
		public var _GameOver:bbGameOver;
		
		public function bbGameOverState() 
		{
			super();
			_GameOver = new bbGameOver();
		}
		
		public function set Game(game:BrickBreakerGame):void {_Game = game;}
		
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

			if (_StartGame)
				return getQualifiedClassName(bbGameState);
			else if (_MainMenu)
				return getQualifiedClassName(bbMenuState);
			return Name;
		}
	}
}