package HubGraphics
{
	import flash.geom.*;
	
	public class hParticleSystem
	{
		private var _ActiveParticles:Array = new Array();
		private var _InactiveParticles:Array = new Array();

		private var _MaxParticles:uint;
		
		public function hParticleSystem(maxParticles:uint)
		{
			_MaxParticles = maxParticles;
			
			for (var i:uint = 0; i < maxParticles; i++)
			{
				_InactiveParticles.push(new hParticle());
			}
		}
		
		public function ActivateParticle():hParticle
		{
			if (_InactiveParticles.length == 0)
				return null;
				
			var newParticle:hParticle = _InactiveParticles.pop();
			newParticle.Active = true;
			newParticle.Visible = true;
			newParticle.Reset();
			_ActiveParticles.push(newParticle);
			
			return newParticle;
		}
		
		public function DeactivateAllParticles():void
		{
			while (_ActiveParticles.length > 0)
			{
				_InactiveParticles.push(_ActiveParticles.pop());
			}			
		}
		
		public function Update(elapsedTime:Number):void
		{
			for (var i:uint = 0; i < _ActiveParticles.length; i++)
			{
				if (!_ActiveParticles[i].Active) {
					_InactiveParticles.push(_ActiveParticles[i]);
					_ActiveParticles.splice(i, 1);
					i--;
					continue;
				}

				_ActiveParticles[i].Update(elapsedTime);
			}
		}
		
		public function Render():void
		{
			for (var i:uint = 0; i < _ActiveParticles.length; i++)
			{
				_ActiveParticles[i].Render();
			}
		}
	}
}