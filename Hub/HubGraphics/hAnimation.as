package HubGraphics
{
	public class hAnimation
	{
		private var _Name:String = null;

		private var _Duration:Number = 0;

		private var _StartFrame:uint = 0;
		private var _EndFrame:uint = 0;

		private var _Loops:Boolean = false;

		public function hAnimation(name:String)
		{
			_Name = name;
		}
		
		public function get Name():String {return _Name;}

		public function get Duration():Number {return _Duration;}
		public function get StartFrame():uint {return _StartFrame;}
		public function get EndFrame():uint {return _EndFrame;}
		public function get Loops():Boolean {return _Loops;}

		public function set Duration(duration:Number):void {_Duration = duration;}
		public function set StartFrame(startFrame:uint):void {_StartFrame = startFrame;}
		public function set EndFrame(endFrame:uint):void {_EndFrame = endFrame;}
		public function set Loops(loops:Boolean):void {_Loops = loops;}
		
		public function CurrentFrame(elapsedTime:Number):uint
		{
			if (!_Duration)
				return _StartFrame;

			if (elapsedTime >= _Duration) {
				if (_Loops)
					elapsedTime = elapsedTime % _Duration;
				else
					return _EndFrame;
			}
		
			return uint((elapsedTime / _Duration) * (_EndFrame - _StartFrame) + _StartFrame);
		}
	}
}