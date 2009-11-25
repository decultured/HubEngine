package bbGameStates 
{
	import HubGaming.*;
	import flash.display.BitmapData;
	import flash.geom.*;
	import flash.utils.*;
	import HubGraphics.*;
	
	public class bbMenuState extends hGameState
	{
		private var _CurrentColor:Number = 0;

		public function bbMenuState() 
		{
			super();
		}
		
		public override function Start():void
		{
			_CurrentColor = 0;
		}
		
		public override function Stop():void
		{
		}
		
		public override function Run(elapsedTime:Number):String
		{
			_CurrentColor += 0x050505;

			hGlobalGraphics.Canvas.Begin(true, _CurrentColor);
			hGlobalGraphics.Canvas.End();

			if (_CurrentColor > 0xffffff)
				return getQualifiedClassName(bbLoaderState);
			else
				return Name;
		}
	}
}