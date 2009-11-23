
import mx.core.Application;
import mx.controls.Alert;
import flash.display.*;
import flash.geom.*;
import flash.filters.*;
import HubGraphics.*;
import HubMath.*;
import flash.events.*;
import mx.events.*;

public var FileName:String;

public var Graph:StreamGraph;
public var DataURL:String;
public var ImageURL:String;

private var _ViewSprite:Sprite = new Sprite();

public function Initialize():void
{
	this.rawChildren.addChild(_ViewSprite);
	
	Graph = new StreamGraph(_ViewSprite, new Point(Application.application.width, Application.application.height));

	DataURL = Application.application.parameters.data_url;

	try {
		Graph.Load(DataURL);
		Graph.addEventListener(StreamGraph.LOAD_COMPLETE, LoadComplete);
	} catch (err:Error)
	{
		Alert.show("DATA NOT FOUND!", 'Alert Box', mx.controls.Alert.OK);
	}
}

public function Render():void
{
	if (!Graph)
		return;
		
	Graph.Render();
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
	
	Graph.Resize(new Point(Application.application.width, Application.application.height));
	
	Render();
}