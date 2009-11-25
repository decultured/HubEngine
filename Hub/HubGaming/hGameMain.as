package HubGaming 
{
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.events.TimerEvent;


	
	public class hGameMain 
	{
		private static var _instance:hGameMain = new hGameMain();

      	public function hGameMain()
        {
            if (_instance != null)
            {
                throw new Error("hGameMain can only be accessed through hGameMain.instance");
            }
        }

        public static function get instance():hGameMain
        {
            return _instance;
        }
		
		public function hGameMain()
		{
			_StateMachine = new hGameStateMachine();
		}

		public function get StateMachine():hGameStateMachine { return _StateMachine; }
		public function get ElapsedTime():uint { return _ThisTime - _LastTime; }

		public function StartLoop():void
		{
			_StateMachine.CurrentState.Start();
			_ThisTime = getTimer();
			_GameTimer= new Timer(1);
			_GameTimer.addEventListener("timer", MainLoop);
			_GameTimer.start();
		}
		
		protected function RunFrame(event:TimerEvent):void
		{
			_LastTime = _ThisTime;
			_ThisTime = getTimer();
			
			if (_StateMachine != null)
				_StateMachine.Run(_ThisTime - _LastTime);
		}
	}
}