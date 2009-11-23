
import mx.core.Application;
import mx.controls.Alert;
import flash.display.*;
import flash.geom.*;
import flash.filters.*;
import mx.core.BitmapAsset;
import HubGraphics.*;
import HubMath.*;
import HubGaming.*;
import flash.events.*;
import mx.events.*;
import nl.demonsters.debugger.MonsterDebugger;

public var ViewBitmap:BitmapData;
public var ViewBitmapAsset:BitmapAsset;
public var MainGame:BrickBreaker;

private var debugger:MonsterDebugger;
			
public function Initialize():void
{
	debugger = new MonsterDebugger(this);
	MonsterDebugger.trace(this, "Hello World!")

	MainGame = new BrickBreaker(ViewBitmap);
	AppResize(null);
	MainGame.StartLoop();

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
	
	MainGame.ResetCanvas(ViewBitmap);

}
