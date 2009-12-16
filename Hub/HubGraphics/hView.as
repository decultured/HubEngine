package HubGraphics
{
	import mx.controls.*;
	import mx.core.BitmapAsset;
	import flash.display.*;
	import flash.geom.*;
	
	public class hView
	{
		private var _BitmapData:BitmapData;
		private var _BitmapAsset:BitmapAsset;
		private var _Image:Image;
		private var _Bounds:Rectangle;

		public function get Bounds():Rectangle {return _Bounds;}
		public function get ViewImage():Image {return _Image;}
		public function get ViewBitmapData():BitmapData {return _BitmapData;}
		public function get Width():Number {if (_BitmapData) return _BitmapData.width; else return 0;}
		public function get Height():Number {if (_BitmapData) return _BitmapData.height; else return 0;}

		public function hView(viewImage:Image)
		{
			_Image = viewImage;
			Initialize();
		}
		
		public function Initialize():void
		{
			_BitmapData = new BitmapData(_Image.width, _Image.height, false, 0xffffff);
			_BitmapAsset = new BitmapAsset(_BitmapData);
			_Image.source = _BitmapAsset;
			_Bounds = new Rectangle(0, 0, _Image.width, _Image.height);
		}
		
		public function Begin(clear:Boolean = true, clearColor:uint = 0xffffff):void 
		{
			_BitmapData.lock();
			
			if (clear)
				_BitmapData.fillRect(_Bounds, clearColor);
		}
		
		public function End():void
		{
			_BitmapData.unlock();			
		}
	}
}