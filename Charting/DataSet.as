package Visualization.Charting 
{
	public class DataSet 
	{
		public var DataTypes:Array = new Array();
		public var Data:Array = new Array();
		public var Categories:Array = new Array();
		
		public function DataSet() 
		{
			
		}

		public function AddDataType(id:String, title:String, type:String = "number", bindings:String = "", transformType:String = "linear"):DataType
		{
			if (id != null && id.length > 0)
			{
				if (title == null || title.length == 0)
					title = id;
				
				var newDataType:DataType = new DataType(id, title, type, bindings, transformType);
				
				DataTypes[id] = newDataType;
				return newDataType;
			}
			return null;
		}
		
		public function AddDataPoint(id:String, displayName:String = null):DataPoint
		{
			if (id != null && id.length > 0 && Data[id] == undefined)
			{
				var newData:DataPoint = new DataPoint(id, displayName);
				Data[id] = newData;
				return Data[id];
			}
			else if (Data[id] != null)
			{
				var dataPoint:DataPoint = Data[id];
				
				dataPoint.DisplayName = displayName;
				return Data[id];
			}
			else	
				return null;
		}
		
		public function SetDataPointValue(dataPointID:String, id:String, value:Number, displyName:String = null):Boolean
		{
			if (dataPointID == null)
				return false;
			
			if (Data[dataPointID] == null)
				if (AddDataPoint(dataPointID) == null)
					return false;
			
			var dataPoint:DataPoint = Data[dataPointID]; 			

			dataPoint.SetDataByID(id, value, displyName);

			if (DataTypes[id] == null)
			{
				var newDataType:DataType = new DataType(id, id);
				DataTypes[id] = newDataType;			
			}
			var dataType:DataType = DataTypes[id];
			dataType.SetMinMaxValueSoft(value);

			return true;
		}
		
		public function SetDataPointCategory(dataPointID:String, category:String):void
		{
			if (dataPointID == null)
				return;
			
			if (Data[dataPointID] == null)
				AddDataPoint(dataPointID);

			var dataPoint:DataPoint = Data[dataPointID]; 
			if (dataPoint.IsInCategory(category))
				return;
			
			dataPoint.AddCategory(category);
			
			if (Categories[category] == null)
				Categories[category] = 1;
			else
				Categories[category]++;
		}

		public function TransformData():void
		{
			var dataValue:Number = 0;
			var dataType:DataType = null;
			
			for each (var dataPoint:DataPoint in Data) {
				for (var id:String in dataPoint.Data) {
					dataValue = dataPoint.Data[id];
					dataType = DataTypes[id];

					if (dataType == null)
						continue;
						
					dataPoint.SetTransformDataByID(id, dataType.Transform(dataValue));
				}
			}
		}
		
		///////////////////////////////////////////
		// Private Members
		///////////////////////////////////////////

	}
	
}