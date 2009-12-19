import flash.display.*;
import flash.geom.*;
import flash.filters.*;
import HubGraphics.*;
import HubMath.*;
import HubGaming.*;
import HubInput.*;
import flash.events.*;
import mx.events.*;
import nl.demonsters.debugger.MonsterDebugger;

public var MainGame:Aeroblox;
private var debugger:MonsterDebugger;
private var StartLevel:String;

public function Initialize():void
{
	debugger = new MonsterDebugger(this);
/*	MonsterDebugger.trace(this, "Hello World!");*/

	MainGame = new Aeroblox();
	hGlobalInput.Initialize(ViewImage);

	StartLevel = Application.application.parameters.start_level;
	MainGame.Game.StartLevel = StartLevel;
	MainGame.Game.CurrentLevel = StartLevel;
	MainGame.Game.NextLevel = null;

	AppResize(null);
}

public function AppResize(event:Event):void
{
	if (!ViewImage)
		return;

	hGlobalGraphics.Initialize(ViewImage);
}

public function EnterFrame(event:Event):void
{
	if (MainGame)
		MainGame.Run();
}