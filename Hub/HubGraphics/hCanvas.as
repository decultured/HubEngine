package HubGraphics
{
	import flash.display.*;
	import flash.geom.*;
	
	public class hCanvas
	{
		private var _ViewBitmap:BitmapData;
		private var _Bounds:Rectangle = new Rectangle(0,0,0,0);
		
		public function get Width():Number {return _Bounds.width;}
		public function get Height():Number {return _Bounds.height;}
		
		public function set ViewBitmap(viewBitmap:BitmapData):void
		{
			_ViewBitmap = viewBitmap;
			_Bounds = new Rectangle(0, 0, _ViewBitmap.width, _ViewBitmap.height);
		}

		public function get ViewBitmap():BitmapData
		{
			return _ViewBitmap;
		}
		
		public function Begin(clear:Boolean = true, clearColor:uint = 0xffffff):void 
		{
			_ViewBitmap.lock();
			
			if (clear)
				_ViewBitmap.fillRect(_Bounds, clearColor);
		}
		
		public function End():void
		{
			_ViewBitmap.unlock();			
		}
	}
}