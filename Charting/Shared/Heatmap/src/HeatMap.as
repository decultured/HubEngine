package  
{
	import flash.display.BitmapData;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import Visualization.Charting.DataPoint;
	import Visualization.Charting.DataType;
	import Visualization.Graphics.gGradient;
	import Visualization.Graphics.gGradientMap;
	import Visualization.Graphics.gImage;
	import Visualization.Charting.DataSet;

	public class HeatMap 
	{
		private var GradientMap:gGradientMap = new gGradientMap();
		
		private var GradientList:Vector.<gGradient> = new Vector.<gGradient>();
		private var CurrentGradient:int = 0;
		
		public var GradientImage:gImage;
		
		public var HeatMapData:DataSet = new DataSet();
		public var ViewBitmap:BitmapData;
		
		public var XML_URL:String = "";
		
		public function HeatMap(viewbitmap:BitmapData) 
		{
			ViewBitmap = viewbitmap;
		}
		
		public function Go(filename:String):void
		{
			XML_URL = filename;
			
			GradientImage = new gImage("Images/spot.png");
			GradientImage.addEventListener(gImage.COMPLETE, ImageDone);
		}
		
		public function ImageDone(event:Event):void
		{
			LoadXMLFile(XML_URL);
		}

		public function LoadXMLFile(filename:String):void
		{
			XML_URL = filename;
			var myXMLURL:URLRequest = new URLRequest(XML_URL);
			var myLoader:URLLoader = new URLLoader(myXMLURL);
			
			HeatMapData.Data = new Array();
			myLoader.addEventListener("complete", DataLoadComplete);	
		}
		
		private function DataLoadComplete(event:Event):Boolean
		{
			var XMLData:XML = new XML( event.target.data );
			//DataLoader.Load(XMLData);
			
			LoadGradients(XMLData);
			LoadData(XMLData);
			
			HeatMapData.TransformData();
			
			Render();

			return true;
		}

		private function LoadGradients(dataSource:XML):Boolean
		{
			for each ( var gradient:XML in dataSource..gradient ) {
				var newGradient:gGradient = new gGradient();
				if (newGradient.LoadFromXML(gradient))
					GradientList.push(newGradient);
			}
			
			return true;
		}
	
		private function LoadData(dataSource:XML):Boolean
		{
			for each ( var dataType:XML in dataSource..dataType ) {
				AddDataType(dataType);
			}
			
			for each ( var dataPoint:XML in dataSource..dataPoint ) {
				AddDataPoint(dataPoint);
			}
			
			return true;
		}
		
		public function AddDataType(dataType:XML):DataType
		{
			if (dataType["@id"] == null)
				return null;
			
			var id:String = dataType["@id"];
			
			var newDataType:DataType = HeatMapData.AddDataType(id, dataType["@type"], dataType["@type"], dataType["@binding"], dataType["@transformType"]);
			
			if (newDataType == null)
				return null;
				
			if (dataType["@minValue"] != undefined)
				newDataType.SetMinValueFixed(dataType["@minValue"]); 
			if (dataType["@maxValue"] != undefined)
				newDataType.SetMaxValueFixed(dataType["@maxValue"]); 
			
			return newDataType;
		}
		
		public function AddDataPoint(dataPoint:XML):void
		{
			if (dataPoint["@id"] == null)
				return;
			
			var id:String = dataPoint["@id"];

			HeatMapData.AddDataPoint(id, dataPoint["@displayName"]);

			for each ( var dataValue:XML in dataPoint..dataValue ) {
				if (dataValue["@id"] != undefined && dataValue["@value"] != undefined)
					HeatMapData.SetDataPointValue(id, dataValue["@id"], dataValue["@value"], dataValue["@displayName"]);
			}
		}
		
		public function Render():void
		{
			var start:int
			var x:uint;

			ViewBitmap.lock();
			ViewBitmap.fillRect(new Rectangle(0, 0, ViewBitmap.width, ViewBitmap.height), 0xff000000);
			for each(var dataPoint:DataPoint in HeatMapData.Data)
			{
				var xCoord:Number = dataPoint.GetTransformDataByID("sentiment");
				var yCoord:Number = dataPoint.GetTransformDataByID("influence");
				var intensity:Number = dataPoint.GetTransformDataByID("date");
				
				GradientImage.RenderSimpleCentered(ViewBitmap, new Point(xCoord * ViewBitmap.width, yCoord * ViewBitmap.height));
			}
			ViewBitmap.unlock();

			var GradMap:gGradientMap = new gGradientMap();
	
			GradMap.ApplyGradientMap(ViewBitmap, ViewBitmap);
		}
	}
	
}