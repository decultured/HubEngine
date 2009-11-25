package  
{
	import flash.display.BitmapData;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import HubGraphics.*;
	import HubGaming.*;
	import bbGameStates.*;

	public class BrickBreaker extends hGameStateMachine
	{
		private var _MenuState:bbMenuState;
		private var _LoaderState:bbLoaderState;
		private var _GameState:bbGameState;

		private var _Game:BrickBreakerGame;

		public function get Game():BrickBreakerGame {return _Game;}

		public function BrickBreaker()
		{
			super();

			_Game = new BrickBreakerGame();

			_MenuState = new bbMenuState();
			_LoaderState = new bbLoaderState();
			_GameState = new bbGameState();
			_GameState.Game = _Game;
			
			AddState(_MenuState, true);		
			AddState(_LoaderState);
			AddState(_GameState);
		}
	}
}
