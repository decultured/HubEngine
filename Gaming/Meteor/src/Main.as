import flash.display.*;
import flash.geom.*;
import flash.filters.*;
import HubGraphics.*;
import HubMath.*;
import HubGaming.*;
import HubInput.*;
import flash.events.*;
import flash.events.*;
import mx.events.*;
import nl.demonsters.debugger.MonsterDebugger;

public var MainGame:MeteorMain;
private var debugger:MonsterDebugger;

private var AuthToken:String;

public function Initialize():void
{
	Security.allowDomain('*');
	debugger = new MonsterDebugger(this);
//	MonsterDebugger.trace(this, "Hello World!");

	MainGame = new MeteorMain();
	hGlobalInput.Initialize(ViewImage);
	
	MainGame.Game.Resources = Application.application.parameters.resources;
	
	/*pplante*/
	AuthToken = Application.application.parameters.auth_token;
	APIInterface.AuthToken = AuthToken;
	
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