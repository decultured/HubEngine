package HubGaming 
{
	import flash.utils.getTimer;
	import flash.events.*;
	
	public class hGameStateMachine
	{
		protected var _States:Object = new Object(); 
		protected var _CurrentState:hGameState = null;
		protected var _DefaultState:hGameState = null;
		protected var _StateResponse:String = null;

		protected var _LastTime:Number = 0;
		protected var _ThisTime:Number = 0;
		protected var _MaxTime:Number = 0;

		public function get States():Object {return _States;}
		public function get CurrentState():hGameState {return _CurrentState;}
		public function get StateResponse():String {return _StateResponse;}
		public function get ElapsedTime():Number {return _ThisTime - _LastTime;}
		public function get MaximumTime():Number {return _MaxTime;}
		public function set MaximumTime(maxTime:Number):void {_MaxTime = maxTime;}

		public function hGameStateMachine()
		{
		}
		
		public function AddState(newState:hGameState, makeDefault:Boolean = false):String
		{
			if (!newState || !newState.Name)
				return null;
			
			_States[newState.Name] = newState;

			if (makeDefault) {
				_DefaultState = newState;
			}
				
			return newState.Name;
		}

		private function ChangeState(newState:hGameState):void
		{
			if (!newState)
				return;

			if (_CurrentState) {
				_CurrentState.Stop();
				_CurrentState.removeEventListener(hGameState.CHANGE_STATE, HandleStateChange);
			}
			_CurrentState = newState;
			_CurrentState.addEventListener(hGameState.CHANGE_STATE, HandleStateChange);
			_CurrentState.Start();
		}
		
		private function SetCurrentStateByName(stateName:String):Boolean
		{
			if (_States[stateName]) {
				ChangeState(_States[stateName]);
				return true;
			}
			return false;
		}
		
		private function SetDefaultState():void
		{
			ChangeState(_DefaultState);
		}
		
		public function GetStateByName(stateName:String):Boolean {return _States[stateName];}
		
		private function HandleStateChange(event:Event):void
		{
			if (!_CurrentState) {
				SetDefaultState();
				return;
			}
			if (!_CurrentState.NextState)
				return;
			
			SetCurrentStateByName(_CurrentState.NextState);
		}
		
		public function Run():void
		{
			_LastTime = _ThisTime;
			_ThisTime = Number(getTimer()) * 0.001;

			if (_MaxTime > 0 && ElapsedTime > _MaxTime)
				_LastTime = _ThisTime - _MaxTime;
			
			if (_CurrentState)
				_CurrentState.Run(ElapsedTime);
			else
				SetDefaultState();
		}
	}
}