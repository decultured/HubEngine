package HubGraphing.Interface 
{
	import flash.geom.Rectangle;
	import HubGraphing.Base.hGraph;
	public class hGraphCanvas
	{
		// General
		public var BackgroundColor:String;
				
		// Labels
		public var GraphName:String;
		public var HorizontalAxisName:String;
		public var VerticalAxisName:String;
		
		// Axis
		public var HAxisMin:Number;
		public var HAxisMax:Number;
		public var NumHDivLines:Number;
		
		public var VAxisMin:Number;
		public var VAxisMax:Number;
		public var NumVDivLines:Number;
		
		// Graph
		public var GraphPosition:Rectangle;
		public var Graph:hGraph;
		
		public function hGraphAxis() 
		{
			
		}
		
		public function Draw()
		{
			DrawLabels();
			DrawAxis();
			DrawGraph();
		}

		public function DrawLabels()
		{
			
		}
		
		public function DrawAxis()
		{
			
		}
		
		public function DrawGraph()
		{
			
		}
	}
	
}