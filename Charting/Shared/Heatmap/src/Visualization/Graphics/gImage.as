package Visualization.Graphics
{
	import flash.display.*;
	import flash.net.URLRequest;
	import flash.events.*;
	import flash.geom.*;
	
	public class gImage extends EventDispatcher
	{
		public static var COMPLETE:String = "complete"

		// Public Variables
		private var LoadedImage:Bitmap;

		// Private Variables
		private var Size:Point = new Point(0, 0);
		private var Bounds:Rectangle = new Rectangle(0, 0, 0, 0);
		private var FileName:String;
		private var Loaded:Boolean = false;
		private var IsAlpha:Boolean = false;
		private var BitmapLoader:Loader;
		
		public function gImage(fileName:String)
		{
			FileName = fileName;
			BitmapLoader = new Loader();
			
			BitmapLoader.contentLoaderInfo.addEventListener(Event.OPEN, HandleOpen);
			BitmapLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, HandleProgress);
			BitmapLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, HandleComplete);

			BitmapLoader.load(new URLRequest(fileName));
		}

		public function GetBitmap():Bitmap
		{
			return LoadedImage;
		}
		
		public function GetSize():Point
		{
			return Size;
		}
		
		public function IsLoaded():Boolean
		{
			return Loaded;
		}
		
		public function RenderSimple(destinationBitmap:BitmapData, destinationPoint:Point):void
		{
			destinationBitmap.copyPixels(LoadedImage.bitmapData, Bounds, destinationPoint); 
		}

		public function RenderSimpleCentered(destinationBitmap:BitmapData, destinationPoint:Point):void
		{
			if (LoadedImage != null)
			destinationBitmap.copyPixels(LoadedImage.bitmapData, Bounds, new Point(destinationPoint.x - (LoadedImage.width / 2.0), destinationPoint.y - (LoadedImage.height / 2.0))); 
		}

		private function HandleOpen(event:Event):void
		{
		}
		
		private function HandleProgress(event:ProgressEvent):void
		{
		}
		
		private function HandleComplete(event:Event):void
		{
			LoadedImage = Bitmap(BitmapLoader.content);
			
			Size.y = LoadedImage.height;
			Size.x = LoadedImage.width;
			
			Bounds.width = LoadedImage.width;
			Bounds.height = LoadedImage.height;
			
			Loaded = true;
			
			dispatchEvent(new Event(gImage.COMPLETE))
		}
	}
}