package HubGraphics
{
	import flash.display.*;
	import flash.net.URLRequest;
	import flash.events.*;
	import flash.geom.*;
	
	public class hImage
	{
		public static var COMPLETE:String = "complete"

		// Public Variables
		private var _Bitmap:Bitmap;

		// Private Variables
		private var _Size:Point = new Point(0, 0);
		private var _Bounds:Rectangle = new Rectangle(0, 0, 0, 0);
		private var _FileName:String;
		private var _Loaded:Boolean = false;
		private var _IsAlpha:Boolean = false;
		private var _BitmapLoader:Loader;
		
		public function hImage(name:String, filename:String = null)
		{
			_Name = name;
		}

		public function get Bitmap():Bitmap	{ return _Bitmap; }
		public function get Width():Point {return _Bounds.width;}
		public function get Height():Point {return _Bounds.height;}
		public function get IsLoaded():Boolean { return _Loaded; }
		public function get Name():String { return _Name; }

		public function SetBitmap(loadedBitmap:Bitmap):void
		{
			if (_Bitmap == null)
				return false;
			
			_Bitmap = loadedBitmap;
			
		}

		public function RenderSimple(destinationBitmap:BitmapData, destinationPoint:Point, bounds:Rectangle = null):void
		{
			if (bounds == null)
				bounds = _Bounds;
			
			destinationBitmap.copyPixels(_Bitmap.bitmapData, bounds, destinationPoint); 
		}

		public function RenderSimpleCentered(destinationBitmap:BitmapData, destinationPoint:Point, bounds:Rectangle = null):void
		{
			if (bounds == null)
				bounds = _Bounds;

			destinationBitmap.copyPixels(_Bitmap.bitmapData, Bounds, new Point(destinationPoint.x - (bounds.width * 0.5), destinationPoint.y - (bounds.height * 0.5))); 
		}

		public function RenderTransformed(destinationBitmap:BitmapData, destinationPoint:Point, transformMatrix:Matrix):void
		{
			destinationBitmap.draw(_Bitmap.bitmapData, matrix, null, null, null, true); 
		}
		
		public function RenderTransformedCentered(destinationBitmap:BitmapData, destinationPoint:Point, transformMatrix:Matrix):void
		{
			var matrix:Matrix = new Matrix();
			matrix.translate(-_Bounds.width * 0.5, -_Bounds.height * 0.5);
			matrix.concat(transformMatrix;)
						
			destinationBitmap.draw(_Bitmap.bitmapData, matrix, null, null, null, true); 
		}
	}
}