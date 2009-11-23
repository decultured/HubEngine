package  
{
	import flash.display.BitmapData;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import HubGraphics.*;
	import HubGaming.*;
	import bbGameStates.*;

	public class BrickBreaker extends hGameMain
	{
		private var _ViewBitmap:BitmapData;
		private var _GameState:bbGameState;	
		private var _MenuState:bbMenuState;	

		public function BrickBreaker(viewBitmap:BitmapData)
		{
			super();

			_GameState = new bbGameState();
			_MenuState = new bbMenuState();

			ResetCanvas(viewBitmap);

			_StateMachine.AddState(_MenuState, true);		
			_StateMachine.AddState(_GameState);		
		}
		
		public function ResetCanvas(viewBitmap:BitmapData):void
		{
			_ViewBitmap = viewBitmap;
			_GameState.ViewBitmap = _ViewBitmap;
			_MenuState.ViewBitmap = _ViewBitmap;
		}
		
		override protected function MainLoop(event:TimerEvent):void
		{
			super.MainLoop(event);
		}
	}
}
