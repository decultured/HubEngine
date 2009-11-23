package Visualization.Graphics 
{
	import flash.display.*;
	import flash.geom.*;
	import flash.display.BitmapData;

	public class gGradientMap 
	{
		public var Palette:Array = new Array(256);
		public var ZeroPallete:Array = new Array(256);
		
		public function gGradientMap() 
		{
			setPalette();
			var i:Number;
			for (i = 0; i < 256; i++)
			{
				ZeroPallete[i] = 0;				
			}
		}

		public function makeARGB(r : Number, g : Number, b : Number, a : Number) : Number
		{
			return( (a << 24) | (r << 16) | (g << 8) | b );
		}

		public function makePalette(rgbFrom : Object, rgbTo : Object, palette : Array, index : Number, steps : Number):void
		{
			var i:Number;
			
			for(i = 0; i < steps; i++)
			{
				var r:Number = rgbFrom["r"] + (((rgbTo["r"] - rgbFrom["r"]) / steps) * i);
				var g:Number = rgbFrom["g"] + (((rgbTo["g"] - rgbFrom["g"]) / steps) * i);
				var b:Number = rgbFrom["b"] + (((rgbTo["b"] - rgbFrom["b"]) / steps) * i);
				
				palette[index + i] = makeARGB(r, g, b, 0);
			}
		}

		public function setPalette():void
		{
			makePalette( { r:0, g:0, b:0 }, { r:0, g:0, b:0 }, Palette, 0, 20);
			makePalette( { r:0, g:0, b:0 }, { r:0, g:0, b:255 }, Palette, 20, 40);
			makePalette( { r:0, g:0, b:255 }, { r:0, g:255, b:255 }, Palette, 60, 40);
			makePalette( { r:0, g:255, b:255 }, { r:0, g:255, b:0 }, Palette, 100, 40);
			makePalette( { r:0, g:255, b:0 }, { r:255, g:255, b:0 }, Palette, 140, 40);
			makePalette( { r:255, g:255, b:0 }, { r:255, g:0, b:0 }, Palette, 180, 40);
			makePalette( { r:255, g:0, b:0 }, { r:255, g:255, b:255 }, Palette, 220, 36);
		}
		public function setPalette3():void
		{
//			makePalette( { r:255, g:255, b:255 }, { r:255, g:255, b:255 }, Palette, 0, 20);
//			makePalette( { r:255, g:255, b:255 }, { r:0, g:0, b:255 }, Palette, 0, 40);
			makePalette( { r:255, g:255, b:255 }, { r:0, g:255, b:255 }, Palette, 0, 60);
			makePalette( { r:0, g:255, b:255 }, { r:0, g:255, b:0 }, Palette, 60, 60);
			makePalette( { r:0, g:255, b:0 }, { r:255, g:255, b:0 }, Palette, 120, 70);
			makePalette( { r:255, g:255, b:0 }, { r:255, g:0, b:0 }, Palette, 190, 60);
			makePalette( { r:255, g:0, b:0 }, { r:128, g:0, b:0 }, Palette, 240, 16); 
//			makePalette( { r:255, g:0, b:0 }, { r:192, g:0, b:0 }, Palette, 251, 5);
		}

		public function setPalette2():void
		{
			var i:Number = 0;
			
			for (i = 0; i < 256; i++)
			{
				Palette[i] = (0x000000ff - i) / 3;
			}
		}

		public function ApplyGradientMap(DestinationBitmap:BitmapData, SourceBitmap:BitmapData):void
		{
			DestinationBitmap.paletteMap(SourceBitmap, new Rectangle(0, 0, SourceBitmap.width, SourceBitmap.height), new Point(0,0), ZeroPallete, ZeroPallete, Palette, null);
		}
	}
}