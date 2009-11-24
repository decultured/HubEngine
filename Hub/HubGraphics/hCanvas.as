package HubGraphics
{
	import flash.display.*;
	import flash.geom.*;
	
	public class hCanvas
	{
		private var _ViewBitmap:BitmapData;
		
		public function set ViewBitmap(viewBitmap:BitmapData):void
		{
			_ViewBitmap = viewBitmap;
		}

		public function get ViewBitmap():BitmapData
		{
			return _ViewBitmap;
		}
		
		public function Begin(clear:Boolean = true, clearColor:uint = 0xffffff):void 
		{
			_ViewBitmap.lock();
			
			if (clear)
				_ViewBitmap.fillRect(new Rectangle(0, 0, _ViewBitmap.width, _ViewBitmap.height), clearColor);
		}
		
		public function End():void
		{
			_ViewBitmap.unlock();			
		}
	}
}