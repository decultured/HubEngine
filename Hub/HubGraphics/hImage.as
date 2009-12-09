package HubGraphics
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.Loader;
    import flash.display.BitmapData;
	import flash.net.URLRequest;
	import flash.events.*;
	import flash.geom.*;
	import nl.demonsters.debugger.MonsterDebugger;
	
	public class hImage extends Sprite
	{
		public static var COMPLETE:String = "complete";
		public static var IO_ERROR:String = "io error";

		private var _Bitmap:BitmapData;

		private var _Size:Point = new Point(0, 0);
		private var _Bounds:Rectangle = new Rectangle(0, 0, 0, 0);
		private var _URL:String;
		private var _Loaded:Boolean = false;
		private var _IsAlpha:Boolean = false;
		private var _Name:String;
		
		public function hImage(name:String, url:String = null)
		{
			_URL = url;
			_Name = name;
		}

		public function get Width():Number {return _Bounds.width;}
		public function get Height():Number {return _Bounds.height;}
		public function get IsLoaded():Boolean { return _Loaded; }
		public function get URL():String { return _URL; }
		public function set URL(url:String):void {_URL = url;}

		public function LoadFromURL(url:String = null):void
		{
			if (!_URL) {
				if (url) {
					_URL = url;
				} else {
					dispatchEvent(new Event(hImage.IO_ERROR));
					return;
				}
			}
			
			var BitmapLoader:Loader = new Loader();
			BitmapLoader.contentLoaderInfo.addEventListener(Event.OPEN, HandleOpen);
			BitmapLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, HandleError);
			BitmapLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, HandleProgress);
			BitmapLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, HandleComplete);
			BitmapLoader.load(new URLRequest(_URL));							
		}

		public function SetBitmap(loadedBitmap:BitmapData):void
		{
			if (_Bitmap == null || !(_Bitmap is BitmapData))
				return;
			
			_Bitmap = loadedBitmap;
			_Loaded = true;
		}

		public function RenderSimple(destinationBitmap:BitmapData, destinationPoint:Point, bounds:Rectangle = null):void
		{
			if (bounds == null || !_Loaded)
				bounds = _Bounds;
			
			destinationBitmap.copyPixels(_Bitmap, bounds, destinationPoint, null, null, true); 
		}

		public function RenderSimpleCentered(destinationBitmap:BitmapData, destinationPoint:Point, bounds:Rectangle = null):void
		{
			if (bounds == null || !_Loaded)
				bounds = _Bounds;

			destinationBitmap.copyPixels(_Bitmap, bounds, new Point(destinationPoint.x - (bounds.width * 0.5), destinationPoint.y - (bounds.height * 0.5)), null, null, true); 
		}

		public function RenderTransformed(destinationBitmap:BitmapData, transformMatrix:Matrix):void
		{
			if (!_Loaded)
				return;
			destinationBitmap.draw(_Bitmap, transformMatrix, null, null, null, true); 
		}
		
		public function RenderTransformedCentered(destinationBitmap:BitmapData, transformMatrix:Matrix):void
		{
			if (!_Loaded)
				return;
				
			var matrix:Matrix = new Matrix();
			matrix.translate(-_Bounds.width * 0.5, -_Bounds.height * 0.5);
			matrix.concat(transformMatrix);
						
			destinationBitmap.draw(_Bitmap, matrix, null, null, null, true); 
		}

		private function HandleOpen(event:Event):void
		{

		}

		private function HandleError(event:IOErrorEvent):void
		{
			dispatchEvent(new Event(hImage.IO_ERROR));
		}
		
		private function HandleProgress(event:ProgressEvent):void
		{
		}
		
		// TODO : Handle error when user does not have permissions.
		// Use the contentLoaderInfo property of Loader to check status,
		// Must be checked BEFORE content is checked at all.  Accessing
		// The content property of a loader object without permissions
		// causes an unreported error. 
		private function HandleComplete(event:Event):void
		{
			var loader:Loader = Loader(event.target.loader);
            var image:Bitmap = Bitmap(loader.content);
			
			if (loader && image && image.bitmapData) {
				_Bitmap = image.bitmapData;
			} else {
				dispatchEvent(new Event(hImage.COMPLETE));
				return;
			}
				
			_Size.y = _Bitmap.height;
			_Size.x = _Bitmap.width;
			
			_Bounds.width = _Bitmap.width;
			_Bounds.height = _Bitmap.height;
			
			_Loaded = true;

			dispatchEvent(new Event(hImage.COMPLETE));
		}		
	}
}