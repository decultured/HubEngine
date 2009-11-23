
import mx.controls.Alert;
import flash.display.*;
import flash.geom.*;
import flash.filters.*;
import mx.controls.Image;
import mx.core.BitmapAsset;
import Visualization.Graphics.*;
import Visualization.Math.*;
import Visualization.DataManagement.*;
import flash.events.*;
import mx.events.*;

public var ViewBitmap:BitmapData;
public var ViewBitmapAsset:BitmapAsset;

public var FileName:String;

public var MainHeatMap:HeatMap;

public function Initialize():void
{
	ViewBitmap = new BitmapData(ViewCanvas.width, ViewCanvas.height, false, 0xffffff);
	ViewBitmapAsset = new BitmapAsset(ViewBitmap);
	ViewCanvas.source = ViewBitmapAsset;
	MainHeatMap = new HeatMap(ViewBitmap);
	
	MainHeatMap.Go("Data/test_data.xml");
}

public function AppResize(event:Event):void
{
	trace ("ASDF");
}