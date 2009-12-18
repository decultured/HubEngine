package HubGraphics
{
	
	public class hAnimatedSprite extends hSprite
	{
		private var _Animating:Boolean = false;
		private var _FrameTime:Number = 0;
		private var _CurrentAnimation:String = null;
	
		public function get FrameTime():Number {return _FrameTime;}
		public function get CurrentAnimation():String {return _CurrentAnimation;}
		public function set CurrentAnimation(animationName:String):void {_CurrentAnimation = animationName;}
	
		public function hAnimatedSprite() {
			super();
		}
	
		public function StartAnimation(name:String, frameTime:Number = 0):void
		{
			if (!name)
				return;
				
			_CurrentAnimation = name;
			_FrameTime = frameTime;
			_Animating = true;
		}

		public override function Update(elapsedTime:Number):void
		{
			_FrameTime += elapsedTime;
			super.Update(elapsedTime);
		}

		public override function Render():void
		{
			if (_CurrentAnimation && _FrameTime > 0) {
				CurrentFrame = _Image.GetAnimationFrame(_CurrentAnimation, _FrameTime);
			}
			
			super.Render();
		}
	}
}