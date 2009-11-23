package Visualization.Charting 
{
	import flash.display.Loader;
	
	public class DataLoader extends Loader
	{
		
		
		public function DataLoader() 
		{
			
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
	}
	
}