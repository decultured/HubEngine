package abGameStates 
{
	import HubGaming.*;
	import flash.display.BitmapData;
	import flash.geom.*;
	import flash.events.*;
	import flash.utils.*;
	import HubGraphics.*;
	import HubAudio.*;
	import HubInput.*;
	
	public class abGameState extends hGameState
	{
		public var _Game:AerobloxGame;
		
		public function abGameState(name:String)
		{
			super(name);
		}
		
		public function set Game(game:AerobloxGame):void {_Game = game;}
		
		private function HandleNextLevel(event:Event):void
		{ 
			_Game.Reset();
			if (!_Game.NextLevel) {
				ChangeState("GameOverState");	
			}
			_Game.CurrentLevel = _Game.NextLevel;
			ChangeState("LoaderState");
		}
				
		private function HandleGameOver(event:Event):void
		{ 
			ChangeState("GameOverState");
		}

		public override function Start():void
		{
			hGlobalInput.Reset();
			hGlobalInput.GetFocus();
			_Game.ShowHUD();
			_Game.addEventListener(AerobloxGame.LEVEL_WON, HandleNextLevel);
			_Game.addEventListener(AerobloxGame.GAME_OVER, HandleGameOver);
		}
		  
		public override function Stop():void
		{
			hGlobalAudio.PauseMusic();
			_Game.HideHUD();
			_Game.removeEventListener(AerobloxGame.LEVEL_WON, HandleNextLevel);
			_Game.removeEventListener(AerobloxGame.GAME_OVER, HandleGameOver);
		}
		
		public override function Run(elapsedTime:Number):void
		{
			_Game.Update(elapsedTime);
			hGlobalInput.Update();
			
			hGlobalGraphics.BeginFrame(true, 0xcccccc);
			_Game.Render();
			hGlobalGraphics.EndFrame();

			if (hGlobalInput.Keyboard.KeyJustPressed(hKeyCodes.P) || hGlobalInput.Keyboard.KeyJustPressed(hKeyCodes.PAUSE) || !hGlobalInput.ApplicationActive)
				ChangeState("PausedState");
			if (hGlobalInput.Keyboard.KeyPressed(hKeyCodes.ESC)) {
				ChangeState("MenuState");
			}
		}
	}
}