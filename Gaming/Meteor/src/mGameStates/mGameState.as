package mGameStates 
{
	import HubGaming.*;
	import flash.display.BitmapData;
	import flash.geom.*;
	import flash.events.*;
	import flash.utils.*;
	import HubGraphics.*;
	import HubAudio.*;
	import HubInput.*;
	
	public class mGameState extends hGameState
	{
		public var _Game:MeteorGame;
		
		public function mGameState(name:String)
		{
			super(name);
		}
		
		public function set Game(game:MeteorGame):void {_Game = game;}
		
		private function HandleNextLevel(event:Event):void
		{ 
			_Game.Reset();
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
			// Forces draw of shields progress bar
			_Game.Shields = _Game.Shields;
			_Game.addEventListener(MeteorGame.LEVEL_WON, HandleNextLevel);
			_Game.addEventListener(MeteorGame.GAME_OVER, HandleGameOver);
		}
		  
		public override function Stop():void
		{
			hGlobalAudio.PauseMusic();
			_Game.HideHUD();
			_Game.removeEventListener(MeteorGame.LEVEL_WON, HandleNextLevel);
			_Game.removeEventListener(MeteorGame.GAME_OVER, HandleGameOver);
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