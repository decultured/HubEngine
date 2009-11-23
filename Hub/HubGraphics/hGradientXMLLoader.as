package HubGraphics
{
	
	public class hGradientXMLLoader 
	{
		
		public function hGradientXMLLoader() 
		{
			
		}
		
		private function LoadGradientFromXML()
		{
			Editor.NewWorld(XMLData.meta[0].width[0], XMLData.meta[0].width[0]);
			
			for each (var element:XML in XMLData.child("colors").elements())
			{
				var FloorTile = Editor.World.Map.Map[element.@x][element.@y];
				
				if (!FloorTile)
					continue;
					
				FloorTile.ImageFileName = element;
				FloorTile.Walkable = element.@walkable;
				FloorTile.Depth = element.@depth;
			}
		}

	}
	
}