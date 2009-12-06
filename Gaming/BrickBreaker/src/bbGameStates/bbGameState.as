package bbGameStates 
{
	import HubGaming.*;
	import flash.display.BitmapData;
	import flash.geom.*;
	import flash.utils.*;
	import HubGraphics.*;
	import HubInput.*;
	
	public class bbGameState extends hGameState
	{
		public var _Game:BrickBreakerGame;
		
		public function bbGameState() 
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
			_Game.Update(elapsedTime);

			hGlobalGraphics.Canvas.Begin(true, 0xcccccc);
			_Game.Render();
			hGlobalGraphics.Canvas.End();

			if (hGlobalInput.Keyboard.KeyPressed(hKeyCodes.P) || hGlobalInput.Keyboard.KeyPressed(hKeyCodes.UP_ARROW))
				return getQualifiedClassName(bbPausedState);
			return Name;
		}
	}
}