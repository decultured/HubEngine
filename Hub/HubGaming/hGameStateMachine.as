package HubGaming 
{
	import flash.utils.getTimer;

	public class hGameStateMachine
	{
		protected var _States:Object = new Object(); 
		protected var _CurrentState:hGameState = null;
		protected var _DefaultState:hGameState = null;
		protected var _StateResponse:String = null;

		protected var _LastTime:Number = 0;
		protected var _ThisTime:Number = 0;

		public function get States():Object {return _States;}
		public function get CurrentState():hGameState {return _CurrentState;}
		public function get StateResponse():String {return _StateResponse;}
		public function get ElapsedTime():Number { return _ThisTime - _LastTime; }

		public function hGameStateMachine()
		{
		}
		
		public function AddState(newState:hGameState, makeDefault:Boolean = false):String
		{
			if (newState == null)
				return null;
			
			_States[newState.Name] = newState;
			
			if (makeDefault)
				_DefaultState = newState;
				
			return newState.Name;
		}
		
		public function SetCurrentStateByName(stateName:String):Boolean
		{
			if (_States[stateName]) {
				_CurrentState = _States[stateName];
				return true;
			}
			return false;
		}
		
		public function GetStateByName(stateName:String):Boolean {return _States[stateName];}
		
		public function Run():void
		{
			_LastTime = _ThisTime;
			_ThisTime = Number(getTimer()) * 0.001;
			
			if (_CurrentState != null) {
				_StateResponse = _CurrentState.Run(ElapsedTime);
				if (_StateResponse != _CurrentState.Name && _States[_StateResponse] != null) {
					_CurrentState.Stop();
					_CurrentState = _States[_StateResponse];
					_CurrentState.Start();
				}
			} else if (_DefaultState != null) {
				_CurrentState = _DefaultState;
				_CurrentState.Start();				
			}
		}
	}
}