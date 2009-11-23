package HubGraphing.HubGraphData
{
	import mx.utils.HashUtil;

	public class hDataType 
	{
		public var ID:String;
		public var Title:String;
		public var Type:String;
		public var Bindings:Array = new Array();
		
		private var TransformType:String = "linear";		

		private var _MinValue:Number = Number.MAX_VALUE;
		private var _MaxValue:Number = Number.MIN_VALUE;

		private var _FixedMaxValue:Boolean = false;
		private var _FixedMinValue:Boolean = false;
		
		public function hDataType(id:String, title:String, type:String = "number", bindings:String = "", transformType:String = "linear") 
		{
			ID = id;
			Title = title;
			Type = type;
			Bindings = bindings.split(",");
			TransformType = transformType;
		}

		public function SetMinValueFixed(val:Number):void { _MinValue = val; _FixedMinValue = true;}
		public function SetMaxValueFixed(val:Number):void { _MaxValue = val; _FixedMaxValue = true;}

		public function SetMinMaxValueSoft(value:Number):void
		{
			SetMinValueSoft(value);
			SetMaxValueSoft(value);
		}
		
		public function SetMinValueSoft(val:Number):void
		{ 
			if (!_FixedMinValue && _MinValue > val)
				_MinValue = val;
		}
		public function SetMaxValueSoft(val:Number):void
		{
			if (!_FixedMaxValue && _MaxValue < val)
				_MaxValue = val;
		}
		
		public function get MaxValue():Number {return _MaxValue}
		public function get MinValue():Number {return _MinValue}

		public function Transform(inputVal:Number):Number
		{
			return TransformLinear(inputVal);
		}
		
		public function TransformLinear(inputVal:Number):Number
		{
			if (_MaxValue == _MinValue)
				return 0;
			
			return (inputVal - _MinValue) / (_MaxValue - _MinValue);
		}
	}
	
}