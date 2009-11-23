package HubGraphics
{	
	public class hGradient 
	{
		public var Name:String;
		private var _ColorPoints:Array = new Array();
		
		
		public function hGradient() 
		{
			
		}
		
		
		private function SortColorPoints(a:Object, b:Object):Number {
		    if(a.Position > b.Position) {
		        return 1;
		    } else if(a.Position < b.Position) {
		        return -1;
		    } else  {
		        return 0;
		    }
		}
		
		// Notes:
		// Colors should be in hexadecimal form, no alpha - e.g. 0xff0000
		// Positions should be floats from 0.0 to 1.0
		public function AddColorPoint(colorInHex:Number, position:Number):void {
			if (position > 1.0) position = 1.0;
			if (position < 0.0) position = 0.0;
			if (colorInHex < 0x000000) colorInHex = 0x000000;
			if (colorInHex > 0xFFFFFF) colorInHex = 0xFFFFFF;
			
			var NewColorPoint:Object = {ColorInRGB:hGraphicsUtil.HEX2RGB(colorInHex), Position:position};
			_ColorPoints.push(NewColorPoint);
		}
		
		public function GetColorArray(numValues:int):Array {
			if (_ColorPoints.length < 2 || numValues < 1) return null;
			
			var ColorPointsCopy:Array = _ColorPoints;
			ColorPointsCopy.sort(SortColorPoints);

			var First:Object = ColorPointsCopy.shift();
			var Second:Object = new Object();

			if (First.position <= 0.0) {
				Second = ColorPointsCopy.shift();
			} else {
				Second = First;
				First.Position = 0.0;
			}
				
			var Output:Array = new Array(numValues);
			var i:Number;
			for (i = 0; i < numValues; i++)
			{
				var position:Number = Number(i)/Number(numValues);
				
				if (position > Second.Position)
				{
					First = Second;
					if (_ColorPoints.length > 0)
						Second = ColorPointsCopy.shift()
					else
						Second.Position = 1.0;
				}

				if (Second.Position == First.Position) {
					Output[i] = hGraphicsUtil.RGB2HEX(Second.ColorInRGB);
				} else {
					Output[i] = hGraphicsUtil.RGB2HEX({
						r:((position - First.Position) * (Second.ColorInRGB.r - First.ColorInRGB.r)) / (Second.Position - First.Position) + First.ColorInRGB.r,
						g:((position - First.Position) * (Second.ColorInRGB.g - First.ColorInRGB.g)) / (Second.Position - First.Position) + First.ColorInRGB.g,
						b:((position - First.Position) * (Second.ColorInRGB.b - First.ColorInRGB.b)) / (Second.Position - First.Position) + First.ColorInRGB.b
					});
				}
			}			
			
			return Output;
		}
		
		public function GetColorArrayRGB(numValues:int):Array {
			return null;
		}
		
		public function LoadFromXML(gradient:XML):void
		{
			if (gradient["@name"])
			{
				Name = gradient["@name"];
			}
				
			for each ( var stop:XML in gradient..stop ) {
				if (!stop["@color"])
					break;
			
				var col:int = stop["@color"];
				if (col > 16777215) col = 16777215;
				else if (col < 0) col = 0;

			}
		}
		
	}
	
}