package HubGraphics 
{
	public class hGraphicsUtil 
	{
		
		public function hGraphicsUtil() 
		{
			
		}
		
		public static function HEX2RGB ( hexColor : Number ):Object {
			var RGB:Object = {
				r:Number((hexColor & 0xff0000) >> 16),
				g:Number((hexColor & 0x00ff00) >> 8),
				b:Number(hexColor & 0x0000ff)
			}
			return RGB;
		}

		public static function RGB2HEX ( RGB:Object ):Object {
			return (RGB.r << 16) + (RGB.g << 8 ) + RGB.b;
		}
		
	}
	
}