package HubGraphics
{
	import flash.geom.*;
	import nl.demonsters.debugger.MonsterDebugger;
	
	public class hParticle extends hAnimatedSprite
	{
		private var _LifeSpan:Number = 0;
		private var _ElapsedTime:Number = 0;

		public function set LifeSpan(lifeSpan:Number):void {_LifeSpan = lifeSpan;}

		public function hParticle()
		{
			super();
		}

		public function Reset():void
		{
			_ElapsedTime = 0;
		}

		public override function Update(elapsedTime:Number):void
		{
			_ElapsedTime += elapsedTime;
			
			if (_LifeSpan < _ElapsedTime) {
				Active = false;
				Visible = false;
				return;
			}

			super.Update(elapsedTime);
		}
	}
}