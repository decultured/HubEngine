package HubGraphing.HubGraphData
{
	public class hDataSet 
	{
		public var DataTypes:Array = new Array();
		public var Data:Array = new Array();
		public var Categories:Array = new Array();
		
		public function hDataSet() 
		{
			
		}

		public function AddDataType(id:String, title:String, type:String = "number", bindings:String = "", transformType:String = "linear"):hDataType
		{
			if (id != null && id.length > 0)
			{
				if (title == null || title.length == 0)
					title = id;
				
				var newDataType:hDataType = new hDataType(id, title, type, bindings, transformType);
				
				DataTypes[id] = newDataType;
				return newDataType;
			}
			return null;
		}
		
		public function AddDataPoint(id:String, displayName:String = null):hDataPoint
		{
			if (id != null && id.length > 0 && Data[id] == undefined)
			{
				var newData:hDataPoint = new hDataPoint(id, displayName);
				Data[id] = newData;
				return Data[id];
			}
			else if (Data[id] != null)
			{
				var dataPoint:hDataPoint = Data[id];
				
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
			
			var dataPoint:hDataPoint = Data[dataPointID]; 			

			dataPoint.SetDataByID(id, value, displyName);

			if (DataTypes[id] == null)
			{
				var newDataType:hDataType = new hDataType(id, id);
				DataTypes[id] = newDataType;			
			}
			var dataType:hDataType = DataTypes[id];
			dataType.SetMinMaxValueSoft(value);

			return true;
		}
		
		public function SetDataPointCategory(dataPointID:String, category:String):void
		{
			if (dataPointID == null)
				return;
			
			if (Data[dataPointID] == null)
				AddDataPoint(dataPointID);

			var dataPoint:hDataPoint = Data[dataPointID]; 
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
			var dataType:hDataType = null;
			
			for each (var dataPoint:hDataPoint in Data) {
				for (var id:String in dataPoint.Data) {
					dataValue = dataPoint.Data[id];
					dataType = DataTypes[id];

					if (dataType == null)
						continue;
						
					dataPoint.SetTransformDataByID(id, dataType.Transform(dataValue));
				}
			}
		}
		
		public function Sort(dataId:String, ascending:Boolean):void
		{
			_SortID = dataId;
			
			Data.sort(SortOnID);
		}
		
		///////////////////////////////////////////
		// Private Members
		///////////////////////////////////////////

		private var _SortID:String;
		private var _SortAcending:Boolean; 

		private function SortOnID(a:hDataPoint, b:hDataPoint):Number {
		    var aSortVal:Number = a.GetDataByID(_SortID);
		    var bSortVal:Number = b.GetDataByID(_SortID);

		    if(aSortVal > bSortVal) {
		        return 1;
		    } else if(aSortVal < bSortVal) {
		        return -1;
		    } else  {
		        //aPrice == bPrice
		        return 0;
		    }
		}
	}
	
}