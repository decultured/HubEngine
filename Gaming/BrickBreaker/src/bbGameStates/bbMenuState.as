package bbGameStates 
{
	import HubGaming.*;
	import flash.display.BitmapData;
	import flash.geom.*;
	import flash.utils.*;
	import HubGraphics.*;
	
	public class bbMenuState extends hGameState
	{
		private var _ViewBitmap:BitmapData;
		private var _CurrentColor:Number = 0;

		public function bbMenuState() 
		{
			super();
		}
		
		public function set ViewBitmap(viewBitmap:BitmapData):void { _ViewBitmap = viewBitmap; }
		public function get ViewBitmap():BitmapData { return _ViewBitmap; }
		
		public override function Start():void
		{
			_CurrentColor = 0;
		}
		
		public override function Stop():void
		{
		}
		
		public override function Run(elapsedTime:uint):String
		{
			_ElapsedTime = elapsedTime;

			_ViewBitmap.lock();

			_CurrentColor += 0x010101;
			_ViewBitmap.fillRect(new Rectangle(0, 0, _ViewBitmap.width, _ViewBitmap.height), _CurrentColor);
			_ViewBitmap.unlock();			

			if (_CurrentColor > 0xffffff)
				return getQualifiedClassName(bbGameState);
			else
				return Name;
		}
	}
}