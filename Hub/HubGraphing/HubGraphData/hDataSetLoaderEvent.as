package HubGraphing.HubGraphData
{
	import flash.events.Event;

	public class hDataSetLoaderEvent extends Event
	{
		public static const COMPLETE:String = "Complete";
		
		public var DataSet:hDataSet = null;
		public function hDataSetLoaderEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, dataSet:hDataSet = null)
		{
			super(type, bubbles, cancelable);
			
			DataSet = dataSet;
		}
		
		public override function clone():Event
		{
			return new hDataSetLoaderEvent(type, bubbles, cancelable, DataSet);
		}
		
		public override function toString():String
		{
			return formatToString("DataLoaderEvent", "type", "bubbles", "cancelable", "eventPhase", "dataSet");
		}
	}
}