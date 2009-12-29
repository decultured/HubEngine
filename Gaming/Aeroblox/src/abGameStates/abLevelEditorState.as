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
	
	public class abLevelEditorState extends hGameState
	{
		private var _Game:AerobloxGame;
		public var _EditorHUD:abLevelEditorMain;
		
		public function abLevelEditorState(name:String)
		{
			super(name);
			_EditorHUD = new abLevelEditorMain();
		}
		
		public function set Game(game:AerobloxGame):void {_Game = game;}
		
		public override function Start():void
		{
			hGlobalGraphics.View.ViewImage.addChild(_EditorHUD);
		}
		
		public override function Stop():void
		{
			hGlobalGraphics.View.ViewImage.removeChild(_EditorHUD);
		}
		
		public override function Run(elapsedTime:Number):void
		{
			hGlobalInput.Update();
			hGlobalGraphics.BeginFrame(true, 0xcccccc);
			_Game.Render();
			hGlobalGraphics.EndFrame();
		}
	}
}