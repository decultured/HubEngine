﻿package HubGraphics
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
		public static var PROGRESS:String = "progress";
		public static var IO_ERROR:String = "io error";

		private var _Bitmap:BitmapData;

		private var _Size:Point = new Point(0, 0);
		private var _Offset:Point = new Point(0, 0);
		private var _Bounds:Rectangle = new Rectangle(0, 0, 0, 0);
		private var _URL:String;
		private var _Loaded:Boolean = false;
		private var _IsAlpha:Boolean = false;
		private var _Name:String;
		
		private var _Segmented:Boolean = false;
		private var _Segments:Array;
		private var _SegmentWidth:uint = 0;
		private var _SegmentHeight:uint = 0;
		
		public function get OffsetX():Number {return _Offset.x;}
		public function get OffsetY():Number {return _Offset.y;}
		public function set OffsetX(offsetX:Number):void {_Offset.x = offsetX;}
		public function set OffsetY(offsetY:Number):void {_Offset.y = offsetY;}
		public function get Width():Number {return _Bounds.width;}
		public function get Height():Number {return _Bounds.height;}
		public function set Loaded(isLoaded:Boolean):void {_Loaded = isLoaded;}
		public function get Loaded():Boolean { return _Loaded; }
		public function get Name():String { return _Name; }
		public function get URL():String { return _URL; }
		public function set URL(url:String):void {_URL = url;}

		public function hImage(name:String, url:String = null)
		{
			_URL = url;
			_Name = name;
		}

		public function LoadFromURL(url:String = null):void
		{
			if (!_URL) {
				if (url) {
					_URL = url;
				} else {
					MonsterDebugger.trace(this, "No URL provided for: " +_Name);
					
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

		public function SetSegmentSize(segmentWidth:uint, segmentHeight:uint):void
		{
			_SegmentWidth = segmentWidth;
			_SegmentHeight = segmentHeight;
		}
		
		private function Segment():void
		{
			if (!_SegmentWidth || !_SegmentHeight || _SegmentWidth > Width || _SegmentHeight > height)
				return;
			
			_Segments = new Array();
			
			var SegmentsX:uint = uint(_Bounds.width / _SegmentWidth);
			var SegmentsY:uint = uint(_Bounds.width / _SegmentHeight);

			for (var column:uint = 0; column < SegmentsX; column++)
			{
				for (var row:uint = 0; row < SegmentsY; row++)
				{
					_Segments.push(new Rectangle(column * _SegmentWidth, row * _SegmentHeight, _SegmentWidth, _SegmentHeight));
				}
			}
			
			if (_Segments.length)
				_Segmented = true;
		}

		public function GetSegmentBounds(segment:uint):Rectangle
		{
			if (!_Segmented || !_Segments || segment >= _Segments.length)
				return _Bounds;
			
			return _Segments[segment];
		}

		public function SetBitmap(loadedBitmap:BitmapData):void
		{
			if (_Bitmap == null || !(_Bitmap is BitmapData))
				return;
			
			_Bitmap = loadedBitmap;
			_Loaded = true;
		}

		public function RenderSimple(destinationBitmap:BitmapData, destinationPoint:Point, segment:uint = 0):void
		{
			if (!_Loaded)
				return;
			
			var sourceBounds:Rectangle = GetSegmentBounds(segment);
			
			destinationBitmap.copyPixels(_Bitmap, sourceBounds, new Point(destinationPoint.x + _Offset.x, destinationPoint.y + _Offset.y), null, null, true); 
		}

		public function RenderSimpleCentered(destinationBitmap:BitmapData, destinationPoint:Point, segment:uint = 0):void
		{
			if (!_Loaded)
				return;
			
			var sourceBounds:Rectangle = GetSegmentBounds(segment);

			destinationBitmap.copyPixels(_Bitmap, sourceBounds, new Point(destinationPoint.x - (sourceBounds.width * 0.5), destinationPoint.y - (sourceBounds.height * 0.5)), null, null, true); 
		}

		public function RenderTransformed(destinationBitmap:BitmapData, transformMatrix:Matrix):void
		{
			if (!_Loaded)
				return;

			var matrix:Matrix = new Matrix();
			matrix.translate(_Offset.x, _Offset.y);
			matrix.concat(transformMatrix);

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
			MonsterDebugger.trace(this, "Image IO Error on: " + _URL);
			
			dispatchEvent(new Event(hImage.IO_ERROR));
		}
		
		private function HandleProgress(event:ProgressEvent):void
		{
			dispatchEvent(new Event(hImage.PROGRESS));
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
			
			Segment();

			dispatchEvent(new Event(hImage.COMPLETE));
		}		
	}
}