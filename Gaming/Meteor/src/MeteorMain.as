package  
{
	import flash.display.BitmapData;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import HubGraphics.*;
	import HubGaming.*;
	import mGameStates.*;

	public class MeteorMain extends hGameStateMachine
	{
		private var _MenuState:mMenuState;
		private var _LoaderState:mLoaderState;
		private var _GameState:mGameState;
		private var _PausedState:mPausedState;
		private var _GameOverState:mGameOverState;

		private var _Game:MeteorGame;

		public function get Game():MeteorGame {return _Game;}

		public function MeteorMain()
		{
			super();

			MaximumTime = 0.075;

			_Game = new MeteorGame();

			_MenuState = new mMenuState("MenuState");
			_MenuState.Game = _Game;
			_LoaderState = new mLoaderState("LoaderState");
			_LoaderState.Game = _Game;
			_GameState = new mGameState("GameState");
			_GameState.Game = _Game;
			_PausedState = new mPausedState("PausedState");
			_PausedState.Game = _Game;
			_GameOverState = new mGameOverState("GameOverState");
			_GameOverState.Game = _Game;
			
			AddState(_MenuState, true);		
			AddState(_LoaderState);
			AddState(_GameState);
			AddState(_PausedState);
			AddState(_GameOverState);
		}
	}
}
