package HubGaming 
{
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.events.TimerEvent;
	
	public class hGameMain 
	{
		protected var _GameTimer:Timer;
		protected var _LastTime:uint;
		protected var _ThisTime:uint;
		
		protected var _StateMachine:hGameStateMachine;
		
		public function hGameMain()
		{
			_StateMachine = new hGameStateMachine();
		}

		public function get StateMachine():hGameStateMachine { return _StateMachine; }
		public function get ElapsedTime():uint { return _ThisTime - _LastTime; }

		public function StartLoop():void
		{
			_ThisTime = getTimer();
			_GameTimer= new Timer(1);
			_GameTimer.addEventListener("timer", MainLoop);
			_GameTimer.start();			
		}
		
		
		protected function MainLoop(event:TimerEvent):void
		{
			_LastTime = _ThisTime;
			_ThisTime = getTimer();
			
			if (_StateMachine != null)
				_StateMachine.Run(_ThisTime - _LastTime);
		}
	}
}