package abGameStates 
{
	import HubGaming.*;
	import flash.display.*;
	import flash.geom.*;
	import flash.utils.*;
	import HubGraphics.*;
	import abGameUI.*;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class abMenuState extends hGameState
	{
		public var _Menu:abMenu;
		private var _Game:AerobloxGame;

		public function set Game(game:AerobloxGame):void {_Game = game;}
		
		public function abMenuState(name:String)
		{
			super(name);
			_Menu = new abMenu();
		}
		
		private function StartGameEvent(event:MouseEvent):void
		{
			_Game.CurrentLevel = _Game.StartLevel;
			ChangeState("LoaderState");
		}
		
		private function LevelEditorEvent(event:MouseEvent):void
		{
			ChangeState("LevelEditorState");
		}
		
		public override function Start():void
		{
			hGlobalGraphics.View.ViewImage.addChild(_Menu);
			_Menu.StartGameButton.addEventListener(MouseEvent.CLICK, StartGameEvent);
			_Menu.LevelEditorButton.addEventListener(MouseEvent.CLICK, LevelEditorEvent);
		}
		
		public override function Stop():void
		{
			hGlobalGraphics.View.ViewImage.removeChild(_Menu);
			_Menu.StartGameButton.removeEventListener(MouseEvent.CLICK, StartGameEvent);
			_Menu.LevelEditorButton.removeEventListener(MouseEvent.CLICK, LevelEditorEvent);
		}
	}
}