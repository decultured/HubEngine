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

public function Initialize():void
{
	debugger = new MonsterDebugger(this);
//	MonsterDebugger.trace(this, "Hello World!");

	MainGame = new BrickBreaker();
	
	hGlobalInput.Initialize(ViewImage);
//	application.addEventListener(KeyboardEvent.KEY_UP, hGlobalInput.Keyboard.HandleKeyUp);
//	application.addEventListener(KeyboardEvent.KEY_DOWN, hGlobalInput.Keyboard.HandleKeyDown);
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