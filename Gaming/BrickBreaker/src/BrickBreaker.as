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
		private var _PausedState:bbPausedState;
		private var _GameOverState:bbGameOverState;

		private var _Game:BrickBreakerGame;

		public function get Game():BrickBreakerGame {return _Game;}

		public function BrickBreaker()
		{
			super();

			_Game = new BrickBreakerGame();

			_MenuState = new bbMenuState();
			_MenuState.Game = _Game;
			_LoaderState = new bbLoaderState();
			_LoaderState.Game = _Game;
			_GameState = new bbGameState();
			_GameState.Game = _Game;
			_PausedState = new bbPausedState();
			_PausedState.Game = _Game;
			_GameOverState = new bbGameOverState();
			_GameOverState.Game = _Game;
			
			AddState(_MenuState, true);		
			AddState(_LoaderState);
			AddState(_GameState);
			AddState(_PausedState);
			AddState(_GameOverState);
		}
	}
}
