package HubGraphics
{
	import flash.display.*;
	import flash.net.URLRequest;
	import flash.events.*;
	import flash.geom.*;
	import nl.demonsters.debugger.MonsterDebugger;
	
	public class hImage extends Sprite
	{
		public static var COMPLETE:String = "complete";

		private var _Bitmap:BitmapData;

		private var _Size:Point = new Point(0, 0);
		private var _Bounds:Rectangle = new Rectangle(0, 0, 0, 0);
		private var _FileName:String;
		private var _Loaded:Boolean = false;
		private var _IsAlpha:Boolean = false;
		private var _BitmapLoader:Loader;
		
		public function hImage(filename:String)
		{
			_FileName = filename;
		}

		public function get Bitmap():BitmapData	{ return _Bitmap; }
		public function get Width():Number {return _Bounds.width;}
		public function get Height():Number {return _Bounds.height;}
		public function get IsLoaded():Boolean { return _Loaded; }
		public function get FileName():String { return _FileName; }

		public function LoadFromFilename():void
		{
			var BitmapLoader:Loader = new Loader();
			BitmapLoader.contentLoaderInfo.addEventListener(Event.OPEN, HandleOpen);
			BitmapLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, HandleProgress);
			BitmapLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, HandleComplete);
			BitmapLoader.load(new URLRequest(FileName));							
			MonsterDebugger.trace(this, "Image added! " + FileName);
		}

		public function SetBitmap(loadedBitmap:BitmapData):void
		{
			if (_Bitmap == null)
				return;
			
			_Bitmap = loadedBitmap;
		}

		public function RenderSimple(destinationBitmap:BitmapData, destinationPoint:Point, bounds:Rectangle = null):void
		{
			if (bounds == null)
				bounds = _Bounds;
			
			destinationBitmap.copyPixels(_Bitmap, bounds, destinationPoint, null, null, true); 
		}

		public function RenderSimpleCentered(destinationBitmap:BitmapData, destinationPoint:Point, bounds:Rectangle = null):void
		{
			if (bounds == null)
				bounds = _Bounds;

			destinationBitmap.copyPixels(_Bitmap, bounds, new Point(destinationPoint.x - (bounds.width * 0.5), destinationPoint.y - (bounds.height * 0.5)), null, null, true); 
		}

		public function RenderTransformed(destinationBitmap:BitmapData, transformMatrix:Matrix):void
		{
			destinationBitmap.draw(_Bitmap, transformMatrix, null, null, null, true); 
		}
		
		public function RenderTransformedCentered(destinationBitmap:BitmapData, transformMatrix:Matrix):void
		{
			var matrix:Matrix = new Matrix();
			matrix.translate(-_Bounds.width * 0.5, -_Bounds.height * 0.5);
			matrix.concat(transformMatrix);
						
			destinationBitmap.draw(_Bitmap, matrix, null, null, null, true); 
		}

		private function HandleOpen(event:Event):void
		{
		}
		
		private function HandleProgress(event:ProgressEvent):void
		{
		}
		
		private function HandleComplete(event:Event):void
		{
			MonsterDebugger.trace(this, "Image doner! " + FileName);

			MonsterDebugger.trace(event.target.content, "What is this");

			_Bitmap = event.target.content.bitmapData;
			
			_Size.y = _Bitmap.height;
			_Size.x = _Bitmap.width;
			
			_Bounds.width = _Bitmap.width;
			_Bounds.height = _Bitmap.height;
			
			_Loaded = true;

			MonsterDebugger.trace(this, "More done! " + FileName);
			
			dispatchEvent(new Event(hImage.COMPLETE));
		}		
	}
}