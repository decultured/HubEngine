package bbGameStates 
{
	import HubGaming.*;
	import flash.display.*;
	import flash.geom.*;
	import flash.utils.*;
	import HubGraphics.*;
	import bbGameUI.*;
	import nl.demonsters.debugger.MonsterDebugger;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class bbMenuState extends hGameState
	{
		private var _StartGame:Boolean = false;
		
		public var _Menu:bbMenu;
		
		public function bbMenuState() 
		{
			super();
			_Menu = new bbMenu();
		}
		
		private function StartGameEvent(event:MouseEvent):void { _StartGame = true; }
		
		public override function Start():void
		{
			_StartGame = false;
			hGlobalGraphics.View.ViewImage.addChild(_Menu);
			_Menu.StartGameButton.addEventListener(MouseEvent.CLICK, StartGameEvent);
		}
		
		public override function Stop():void
		{
			hGlobalGraphics.View.ViewImage.removeChild(_Menu);
			_Menu.StartGameButton.removeEventListener(MouseEvent.CLICK, StartGameEvent);
		}
		
		public override function Run(elapsedTime:Number):String
		{
			if (!_StartGame)
				return Name;
			else
				return getQualifiedClassName(bbLoaderState);
		}
	}
}