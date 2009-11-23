
import mx.core.Application;
import mx.controls.Alert;
import flash.display.*;
import flash.geom.*;
import flash.filters.*;
import mx.controls.Image;
import mx.core.BitmapAsset;
import HubGraphics.*;
import HubMath.*;
import flash.events.*;
import mx.events.*;
import nl.demonsters.debugger.MonsterDebugger;

public var ViewBitmap:BitmapData;
public var ViewBitmapAsset:BitmapAsset;

public var FileName:String;

public var MainHeatMap:HeatMap;
public var DataURL:String;
public var ImageURL:String;
	
private var debugger:MonsterDebugger;
			
public function Initialize():void
{
	MainHeatMap = new HeatMap(ViewBitmap);

	DataURL = Application.application.parameters.data_url;
	ImageURL = Application.application.parameters.image_url;

	debugger = new MonsterDebugger(this);
	
	// Send a simple trace
	MonsterDebugger.trace(this, "Hello World!")

	try {
		MainHeatMap.Load(DataURL, ImageURL);
		MainHeatMap.addEventListener(HeatMap.LOAD_COMPLETE, LoadComplete);
	} catch (err:Error)
	{
		Alert.show("DATA NOT FOUND!", 'Alert Box', mx.controls.Alert.OK);
	}
}

public function Render():void
{
	if (!MainHeatMap)
		return;
		
	MainHeatMap.ResetCanvas(ViewBitmap);
	MainHeatMap.Render();
}

public function LoadComplete(event:Event):void
{
	AppResize(null);
	Render();
}

public function AppResize(event:Event):void
{
	if (!ViewCanvas)
		return;
	
//	ViewCanvas.width = Application.application.width;
//	ViewCanvas.height = Application.application.height;

	ViewBitmap = new BitmapData(ViewCanvas.width, ViewCanvas.height, false, 0xffffff);
	ViewBitmapAsset = new BitmapAsset(ViewBitmap);
	ViewCanvas.source = ViewBitmapAsset;
	
	Render();
}