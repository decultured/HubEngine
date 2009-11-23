package Visualization.Graphics 
{
	public class gGradient 
	{
		public var Name:String;
		
		
		public function gGradient() 
		{
			
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