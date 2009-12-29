package mGameStates 
{
	import HubGaming.*;
	import flash.display.*;
	import flash.geom.*;
	import flash.utils.*;
	import HubGraphics.*;
	import mGameUI.*;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class mMenuState extends hGameState
	{
		public var _Menu:mMenu;
		private var _Game:MeteorGame;

		public function set Game(game:MeteorGame):void {_Game = game;}
		
		public function mMenuState(name:String)
		{
			super(name);
			_Menu = new mMenu();
		}
		
		private function StartGameEvent(event:MouseEvent):void
		{
			ChangeState("LoaderState");
		}
		
		public override function Start():void
		{
			hGlobalGraphics.View.ViewImage.addChild(_Menu);
			_Menu.StartGameButton.addEventListener(MouseEvent.CLICK, StartGameEvent);
		}
		
		public override function Stop():void
		{
			hGlobalGraphics.View.ViewImage.removeChild(_Menu);
			_Menu.StartGameButton.removeEventListener(MouseEvent.CLICK, StartGameEvent);
		}
	}
}