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
		public var _GameState:bbGameState;	
		public var _MenuState:bbMenuState;	

		public function BrickBreaker()
		{
			super();

			_GameState = new bbGameState();
			_MenuState = new bbMenuState();

			AddState(_MenuState, true);		
			AddState(_GameState);		
		}
	}
}
