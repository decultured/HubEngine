package HubGaming 
{
	public class hGameStateMachine
	{
		protected var _States:Object; 
		protected var _CurrentState:hGameState = null;
		protected var _StateResponse:String = null;

		public function get States():Object {return _States;}
		public function get CurrentState():hGameState {return _CurrentState;}
		public function get StateResponse():String {return _StateResponse;}

		public function hGameStateMachine()
		{
			_States = new Object();
		}
		
		public function AddState(newState:hGameState, makeDefault:Boolean = false):String
		{
			if (newState == null)
				return null;
			
			_States[newState.Name] = newState;
			
			if (makeDefault)
				_CurrentState = newState;
				
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
		
		public function Run(elapsedTime:uint):void
		{
			if (_CurrentState != null)
			{
				_StateResponse = _CurrentState.Run(elapsedTime);
				if (_StateResponse != _CurrentState.Name && _States[_StateResponse] != null)
				{
					_CurrentState.Stop();
					_CurrentState = _States[_StateResponse];
					_CurrentState.Start();
				}
			}
		}
	}
}