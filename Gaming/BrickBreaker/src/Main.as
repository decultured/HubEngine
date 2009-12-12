import flash.display.Sprite;
import flash.text.TextField;
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

public var MainGame:BrickBreaker;
private var debugger:MonsterDebugger;
private var StartingLevel:String;

public function Initialize():void
{
	debugger = new MonsterDebugger(this);
//	MonsterDebugger.trace(this, "Hello World!");

	MainGame = new BrickBreaker();
	hGlobalInput.Initialize(ViewImage);

	StartingLevel = Application.application.parameters.starting_level;
	MainGame.Game.StartLevel = StartingLevel;
	MainGame.Game.CurrentLevel = StartingLevel;
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