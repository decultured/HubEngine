package  
{
	import flash.display.BitmapData;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import HubGraphics.*;
	import HubGraphing.HubGraphData.*;

	public class HeatMap extends EventDispatcher
	{
		public static var LOAD_COMPLETE:String = "loadComplete";

		private var _HeatMapData:hDataSet = new hDataSet();
		private var _ViewBitmap:BitmapData;
		private var _XML_URL:String = "";
		private var _Image_URL:String = "";
		
		// Gradients
		private var _GradientMap:hGradientMap = new hGradientMap();
		private var _GradientImage:hImage;
		private var _GradientList:Vector.<hGradient> = new Vector.<hGradient>();
		private var _CurrentGradient:int = 0;
		
		public function HeatMap(viewBitmap:BitmapData) 
		{
			_ViewBitmap = viewBitmap;
		}
		
		public function ResetCanvas(viewBitmap:BitmapData):void
		{
			_ViewBitmap = viewBitmap;
		}
		
		public function Load(data_filename:String, image_filename:String):void
		{
			_XML_URL = data_filename;
			_Image_URL = image_filename;
			
			if (!_XML_URL || !_Image_URL)
				return;
				
			_GradientImage = new hImage(_Image_URL);
			_GradientImage.addEventListener(hImage.COMPLETE, ImageDone);
		}
		
		private function ImageDone(event:Event):void
		{
			LoadData();
		}
		
		private function LoadData():void
		{
			var dataSetLoader:hDataSetLoader = new hDataSetLoader(_XML_URL);
			dataSetLoader.addEventListener(hDataSetLoaderEvent.COMPLETE, DataLoadComplete);
		}
		
		private function DataLoadComplete(event:hDataSetLoaderEvent):Boolean
		{
			_HeatMapData = event.DataSet;
			
			if (_HeatMapData == null)
				return false;
			
			dispatchEvent(new Event(HeatMap.LOAD_COMPLETE));

			return true;
		}
		
		public function Render():void
		{
			if (!_ViewBitmap)
				return;
				
			var start:int
			var x:uint;

			_ViewBitmap.lock();
			_ViewBitmap.fillRect(new Rectangle(0, 0, _ViewBitmap.width, _ViewBitmap.height), 0xff000000);
			for each(var dataPoint:hDataPoint in _HeatMapData.Data)
			{
				var xCoord:Number = dataPoint.GetTransformDataByID("sentiment");
				var yCoord:Number = dataPoint.GetTransformDataByID("influence");
				var intensity:Number = dataPoint.GetTransformDataByID("growth");
				
				//TODO: WHY IS THERE PLUS 0.1 on SCALE?
				
				_GradientImage.RenderScaledCentered(_ViewBitmap, new Point(xCoord * _ViewBitmap.width, yCoord * _ViewBitmap.height), intensity + 0.1, intensity + 0.1);
			}
			_ViewBitmap.unlock();

			_GradientMap.ApplyGradientMap(_ViewBitmap, _ViewBitmap);
		}
	}
	
}