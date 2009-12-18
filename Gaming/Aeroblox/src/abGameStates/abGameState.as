package abGameStates 
{
	import HubGaming.*;
	import flash.display.BitmapData;
	import flash.geom.*;
	import flash.utils.*;
	import HubGraphics.*;
	import HubAudio.*;
	import HubInput.*;
	
	public class abGameState extends hGameState
	{
		public var _Game:AerobloxGame;
		
		public function abGameState() 
		{
			super();
		}
		
		public function set Game(game:AerobloxGame):void {_Game = game;}
		
		public override function Start():void
		{
			if (_Game.GameOver)
				_Game.NewGame();

			hGlobalInput.GetFocus();
			_Game.ShowHUD();
		}
		
		public override function Stop():void
		{
			hGlobalAudio.PauseMusic();
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
				return getQualifiedClassName(abPausedState);
			if (hGlobalInput.Keyboard.KeyPressed(hKeyCodes.ESC)) {
				return getQualifiedClassName(abMenuState);
			}
			if (_Game.GameOver) {
				return getQualifiedClassName(abGameOverState);
			}
			if (_Game.LevelWon) {
				if (!_Game.NextLevel) {
					return getQualifiedClassName(abGameOverState);	
				}
				_Game.CurrentLevel = _Game.NextLevel;
				return getQualifiedClassName(abLoaderState);
			}
			return Name;
		}
	}
}