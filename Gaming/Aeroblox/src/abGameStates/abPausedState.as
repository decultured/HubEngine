package abGameStates 
{
	import HubGaming.*;
	import flash.display.BitmapData;
	import flash.geom.*;
	import flash.utils.*;
	import HubGraphics.*;
	import HubInput.*;
	import HubAudio.*;
	import abGameUI.*;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class abPausedState extends hGameState
	{
		private var _Game:AerobloxGame;
		public var _Paused:abPaused;
		
		public function abPausedState(name:String)
		{
			super(name);
			_Paused = new abPaused();
		}
		
		public function set Game(game:AerobloxGame):void {_Game = game;}
		
		private function StartGameEvent(event:MouseEvent):void { ChangeState("GameState"); }

		public override function Start():void
		{
			hGlobalGraphics.View.ViewImage.addChild(_Paused);
			_Paused.StartGameButton.addEventListener(MouseEvent.CLICK, StartGameEvent);
		}
		
		public override function Stop():void
		{
			hGlobalGraphics.View.ViewImage.removeChild(_Paused);
			_Paused.StartGameButton.removeEventListener(MouseEvent.CLICK, StartGameEvent);
		}
		
		public override function Run(elapsedTime:Number):void
		{
			hGlobalInput.Update();
			hGlobalGraphics.BeginFrame(true, 0xcccccc);
			_Game.Render();
			hGlobalGraphics.EndFrame();

			if (hGlobalInput.Keyboard.KeyJustPressed(hKeyCodes.P) || hGlobalInput.Keyboard.KeyJustPressed(hKeyCodes.PAUSE))
				ChangeState("GameState");
		}
	}
}