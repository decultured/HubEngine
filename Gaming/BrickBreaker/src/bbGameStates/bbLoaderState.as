package bbGameStates 
{
	import HubGaming.*;
	import flash.display.BitmapData;
	import flash.geom.*;
	import flash.utils.*;
	import HubGraphics.*;
	import flash.events.*;
	
	public class bbLoaderState extends hGameState
	{
		private var _Complete:Boolean = false;

		public function bbLoaderState() 
		{
			super();
		}
		
		public override function Start():void
		{
			_Complete = false;
			hGlobalGraphics.ImageLibrary.addEventListener(hImageLibrary.COMPLETE, HandleComplete);
			hGlobalGraphics.ImageLibrary.LoadAllUnloadedImages();
		}
		
		public override function Stop():void
		{

		}
		
		public override function Run(elapsedTime:Number):String
		{
			if (_Complete)
				return getQualifiedClassName(bbGameState);
			else
				return Name;
		}
		
		private function HandleComplete(event:Event):void
		{
			_Complete = true;
		}
	}
}