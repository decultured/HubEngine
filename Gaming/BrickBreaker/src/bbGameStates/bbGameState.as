package bbGameStates 
{
	import HubGaming.*;
	import flash.display.BitmapData;
	import flash.geom.*;
	import flash.utils.*;
	import HubGraphics.*;
	import HubInput.*;
	import nl.demonsters.debugger.MonsterDebugger;
	
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
			if (_Game.GameOver)
				_Game.Reset(true);

			hGlobalInput.GetFocus();
			_Game.ShowHUD();
		}
		
		public override function Stop():void
		{
			_Game.HideHUD();
		}
		
		public override function Run(elapsedTime:Number):String
		{
			_Game.Update(elapsedTime);
			hGlobalInput.Update();
			
			hGlobalGraphics.BeginFrame(true, 0xcccccc);
			_Game.Render();
			hGlobalGraphics.EndFrame();

			if (hGlobalInput.Keyboard.KeyJustPressed(hKeyCodes.P) || hGlobalInput.Keyboard.KeyJustPressed(hKeyCodes.PAUSE) || !hGlobalInput.ApplicationActive)
				return getQualifiedClassName(bbPausedState);
			if (hGlobalInput.Keyboard.KeyPressed(hKeyCodes.Q)) {
				return getQualifiedClassName(bbMenuState);
			}
			if (_Game.GameOver) {
				return getQualifiedClassName(bbGameOverState);
			}
			if (_Game.LevelWon) {
				if (!_Game.NextLevel) {
					return getQualifiedClassName(bbGameOverState);	
				}
				_Game.CurrentLevel = _Game.NextLevel;
				return getQualifiedClassName(bbLoaderState);
			}
			return Name;
		}
	}
}