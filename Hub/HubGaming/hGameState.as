package HubGaming 
{
	import flash.utils.*;
	import flash.events.*;
	
	public class hGameState extends EventDispatcher
	{
		public static var CHANGE_STATE:String = "change state";

		protected var _ElapsedTime:Number = 0;
		protected var _NextState:String = null;
		protected var _Name:String = null;
		
		public function get Name():String {return _Name}
		public function get NextState():String {return _NextState;}

		public function hGameState(name:String) 
		{
			_Name = name;
		}

		public function ChangeState(nextState:String):void
		{
			_NextState = nextState;
			dispatchEvent(new Event(CHANGE_STATE));			
		}
		
		public function Start():void
		{
		}
		
		public function Stop():void
		{
		}
		
		public function Run(elapsedTime:Number):void
		{
			_ElapsedTime = elapsedTime;
		}
	}
}