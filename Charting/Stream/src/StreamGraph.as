package  
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import HubGraphics.*;
	import HubGraphing.HubGraphData.*;

	public class StreamGraph extends EventDispatcher
	{
		public static var LOAD_COMPLETE:String = "loadComplete";

		private var _GraphData:hDataSet = new hDataSet();

		private var _Size:Point = new Point();
		private var _Position:Point = new Point();
		
		private var _ViewSprite:Sprite;
		private var _ViewShape:Shape = new Shape();
		
		private var _CurvedLine:hCurvedLine = new hCurvedLine();
		
		private var _ViewBitmap:BitmapData;
		private var _XML_URL:String = "";
		
		public function StreamGraph(viewSprite:Sprite, size:Point) 
		{
			_ViewSprite = viewSprite;
			_Size = size;
			
			_ViewSprite.addChild(_ViewShape);
		}
		
		public function Resize(newSize:Point):void
		{
			_Size = newSize;
		}
		
		public function Load(data_filename:String):void
		{
			_XML_URL = data_filename;
			
			if (!_XML_URL)
				return;

			LoadData();
		}
		
		private function LoadData():void
		{
			var dataSetLoader:hDataSetLoader = new hDataSetLoader(_XML_URL);
			dataSetLoader.addEventListener(hDataSetLoaderEvent.COMPLETE, DataLoadComplete);
		}
		
		private function DataLoadComplete(event:hDataSetLoaderEvent):Boolean
		{
			_GraphData = event.DataSet;
			
			if (_GraphData == null || _GraphData.Data == null || _GraphData.Data.length < 2)
				return false;
			
			_CurvedLine.ClearPoints();

			_GraphData.Sort("sentiment", true);
			
			var scale:Number = (1 / (_GraphData.Data.length - 1)) * 0.35;
			for each(var dataPoint:hDataPoint in _GraphData.Data)
			{
				var xCoord:Number = dataPoint.GetTransformDataByID("sentiment");
				var yCoord:Number = dataPoint.GetTransformDataByID("influence");
	
				_CurvedLine.AddPoint(new Point(xCoord, yCoord), scale);
			}

			dispatchEvent(new Event(StreamGraph.LOAD_COMPLETE));

			return true;
		}
		
		public function Render():void
		{
			if (!_ViewSprite || !_ViewShape || !_CurvedLine)
				return;
				
			_ViewSprite.graphics.clear();
			_ViewShape.graphics.clear();

			_ViewShape.graphics.lineStyle(3, 0x000000, 1 );
//			_ViewShape.graphics.beginFill(0);
			_ViewShape.graphics.moveTo(0, _Size.y);
			_CurvedLine.Draw(_ViewShape, _Position, _Size);
			_ViewShape.graphics.moveTo(_Size.x, _Size.y);
			_ViewShape.graphics.moveTo(0, _Size.y);
			//_CurvedLine.DrawPoints(_ViewShape, 3, _Position, _Size);
		}
	}	
}