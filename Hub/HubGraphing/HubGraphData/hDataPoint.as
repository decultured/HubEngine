package HubGraphing.HubGraphData
{
	public class hDataPoint 
	{
		public var Id:String = "";
		public var DisplayName:String = "";
		
		public var TransformedData:Array = new Array();
		public var Data:Array = new Array();
		public var DataDisplayName:Array = new Array();
		public var Categories:Array = new Array();
		
		public function hDataPoint(id:String = null, displayName:String = null) 
		{
			Id = id;
			DisplayName = displayName;
		}
		
		public function GetDataByID(id:String):Number
		{
			if (Data[id] != null)
				return Data[id];
			else return 0;
		}
		
		public function GetTransformDataByID(id:String):Number
		{
			if (TransformedData[id] != null)
				return TransformedData[id];
			else return 0;
		}
		
		public function SetDataByID(id:String, value:Number, displayName:String = null):void
		{
			if (id != null)
			{
				Data[id] = value;
				
				if (displayName != null && displayName.length > 0)
					DataDisplayName[id] = displayName;
			}	
		}
		
		public function SetTransformDataByID(id:String, value:Number):void
		{
			if (id != null)
				TransformedData[id] = value;
		}
		
		public function IsInCategory(category:String):Boolean
		{
			if (Categories[category] != null)
				return true;
			return false;
		}
		
		public function AddCategory(category:String):void
		{
			Categories[category] = 1;
		}
	}
}