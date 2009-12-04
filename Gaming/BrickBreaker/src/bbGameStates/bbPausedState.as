package bbGameStates 
{
	import HubGaming.*;
	import flash.display.BitmapData;
	import flash.geom.*;
	import flash.utils.*;
	import HubGraphics.*;
	import HubInput.*;
	
	public class bbPausedState extends hGameState
	{
		private var _Game:BrickBreakerGame;
		
		public function bbPausedState() 
		{
			super();
		}
		
		public function set Game(game:BrickBreakerGame):void {_Game = game;}
		
		public override function Start():void
		{
		}
		
		public override function Stop():void
		{
		}
		
		public override function Run(elapsedTime:Number):String
		{
			hGlobalGraphics.Canvas.Begin(true, 0xcccccc);
			_Game.Render();
			hGlobalGraphics.Canvas.End();

			if (hGlobalInput.Keyboard.KeyPressed(hKeyCodes.P) || hGlobalInput.Keyboard.KeyPressed(hKeyCodes.PAUSE))
				return getQualifiedClassName(bbGameState);
			return Name;
		}
	}
}