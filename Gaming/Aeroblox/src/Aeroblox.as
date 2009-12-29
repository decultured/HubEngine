package  
{
	import flash.display.BitmapData;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import HubGraphics.*;
	import HubGaming.*;
	import abGameStates.*;

	public class Aeroblox extends hGameStateMachine
	{
		private var _MenuState:abMenuState;
		private var _LoaderState:abLoaderState;
		private var _GameState:abGameState;
		private var _PausedState:abPausedState;
		private var _GameOverState:abGameOverState;

		private var _Game:AerobloxGame;

		public function get Game():AerobloxGame {return _Game;}

		public function Aeroblox()
		{
			super();

			MaximumTime = 0.075;

			_Game = new AerobloxGame();

			_MenuState = new abMenuState("MenuState");
			_MenuState.Game = _Game;
			_LoaderState = new abLoaderState("LoaderState");
			_LoaderState.Game = _Game;
			_GameState = new abGameState("GameState");
			_GameState.Game = _Game;
			_PausedState = new abPausedState("PausedState");
			_PausedState.Game = _Game;
			_GameOverState = new abGameOverState("GameOverState");
			_GameOverState.Game = _Game;
			
			AddState(_MenuState, true);		
			AddState(_LoaderState);
			AddState(_GameState);
			AddState(_PausedState);
			AddState(_GameOverState);
		}
	}
}
