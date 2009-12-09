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
			hGlobalInput.GetFocus();
		}
		
		public override function Stop():void
		{
		}
		
		public override function Run(elapsedTime:Number):String
		{
			_Game.Update(elapsedTime);

			hGlobalInput.Update();
			hGlobalGraphics.View.Begin(true, 0xcccccc);
			_Game.Render();
			hGlobalGraphics.View.End();

			if (hGlobalInput.Keyboard.KeyJustPressed(hKeyCodes.P) || hGlobalInput.Keyboard.KeyJustPressed(hKeyCodes.PAUSE) || !hGlobalInput.ApplicationActive)
				return getQualifiedClassName(bbPausedState);
			if (hGlobalInput.Keyboard.KeyPressed(hKeyCodes.Q)) {
				_Game.Reset();
				return getQualifiedClassName(bbMenuState);
			}
			return Name;
		}
	}
}