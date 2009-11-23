package bbGameStates 
{
	import HubGaming.*;
	import flash.display.BitmapData;
	import flash.geom.*;
	import flash.utils.*;
	import HubGraphics.*;
	
	public class bbGameState extends hGameState
	{
		private var _ViewBitmap:BitmapData;

		public function bbGameState() 
		{
			super();
		}
		
		public function set ViewBitmap(viewBitmap:BitmapData):void { _ViewBitmap = viewBitmap; }
		public function get ViewBitmap():BitmapData { return _ViewBitmap; }
		
		public override function Start():void
		{
		}
		
		public override function Stop():void
		{
		}
		
		public override function Run(elapsedTime:uint):String
		{
			_ElapsedTime = elapsedTime;

			_ViewBitmap.lock();

			var color:uint = Math.round(Math.random()*0xffffff);
			_ViewBitmap.fillRect(new Rectangle(0, 0, _ViewBitmap.width, _ViewBitmap.height), color);
			_ViewBitmap.unlock();			

			if (color > 0xd0d0d0)
				return getQualifiedClassName(bbMenuState);
			else
				return Name;

			return Name;
		}
	}
}