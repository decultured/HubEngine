package HubGraphics
{
	import flash.display.*;
	import flash.geom.*;
	import flash.display.BitmapData;

	public class hGradientMap 
	{
		public var Palette:Array = new Array(256);
		public static var ZeroPallete:Array = new Array(256);
		
		public function hGradientMap() 
		{
			setDefaultWhitePalette();
			var i:Number;
			for (i = 0; i < 256; i++)
			{
				ZeroPallete[i] = 0;				
			}
		}

		public function setDefaultBlackPalette():void
		{
			var gradient:hGradient = new hGradient();
			
			gradient.AddColorPoint( 0x000000, 0.00);
			gradient.AddColorPoint( 0x000000, 0.08);
			gradient.AddColorPoint( 0x0000FF, 0.23);
			gradient.AddColorPoint( 0x00FFFF, 0.39);
			gradient.AddColorPoint( 0x00FF00, 0.55);
			gradient.AddColorPoint( 0xFFFF00, 0.70);
			gradient.AddColorPoint( 0xFF0000, 0.86);
			gradient.AddColorPoint( 0xFFFFFF, 1.00);

			Palette = gradient.GetColorArray(256);
		}
		public function setDefaultWhitePalette():void
		{
			var gradient:hGradient = new hGradient();
			
			gradient.AddColorPoint(0xFFFFFF, 0.00);
			gradient.AddColorPoint(0xFFFFFF, 0.04);
			gradient.AddColorPoint(0x00FFFF, 0.16);
			gradient.AddColorPoint(0x00FF00, 0.27);
			gradient.AddColorPoint(0xFFFF00, 0.43);
			gradient.AddColorPoint(0xFF8000, 0.59); 
			gradient.AddColorPoint(0xFF0000, 0.74); 
			gradient.AddColorPoint(0x800000, 0.90); 
			gradient.AddColorPoint(0x000000, 1.00); 
			
			Palette = gradient.GetColorArray(256);
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