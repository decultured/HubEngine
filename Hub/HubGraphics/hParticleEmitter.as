package HubGraphics
{
	import flash.geom.*;
	
	public class hParticleEmitter extends hAnimatedSprite
	{
		private var _StartPositionRange:Number = 0;
		private var _StartVelocity:Point = new Point(0,0);
		private var _StartVelocityRange:Point = new Point(0,0);
		private var _StartAcceleration:Point = new Point(0,0);
		private var _StartAccelerationRange:Point = new Point(0,0);
		
		private var _AnimationStartTimeRange:Number = 0;
		private var _ParticleLifespan:Number = 0;
		private var _ParticleLifespanRange:Number = 0;

		private var _Age:Number = 0;
		
		// Lifespan of zero goes forever
		private var _Lifespan:Number = 0;
		
		private var _ParticlesPerSecond:Number = 1;
		private var _ParticlesToEmit:Number = 0;
		
		private var _ParticleSystem:hParticleSystem;
		
		public function set AnimationStartTimeRange(timeRange:Number):void {_AnimationStartTimeRange = timeRange;} 
		public function set StartPositionRange(positionRange:Number):void {_StartPositionRange = positionRange;} 
		public function set StartVelocity(velocity:Point):void {_StartVelocity = velocity;} 
		public function set StartVelocityRange(velocity:Point):void {_StartVelocityRange = velocity;} 
		public function set StartAcceleration(acceleration:Point):void {_StartAcceleration = acceleration;} 
		public function set StartAccelerationRange(acceleration:Point):void {_StartAccelerationRange = acceleration;} 
		public function set ParticlesPerSecond(particlesPerSecond:Number):void {_ParticlesPerSecond = particlesPerSecond;} 
		public function set ParticleLifespan(particleLifespan:Number):void {_ParticleLifespan = particleLifespan;} 
		public function set ParticleLifespanRange(particleLifespanRange:Number):void {_ParticleLifespanRange = particleLifespanRange;} 

		public function hParticleEmitter(particleSystem:hParticleSystem)
		{
			_ParticleSystem = particleSystem;

			super();
		}
		
		public override function Update(elapsedTime:Number):void
		{
			_Age += elapsedTime;		

			if (_Lifespan && _Age > _Lifespan)
				return;
				
			super.Update(elapsedTime);
			
			_ParticlesToEmit += elapsedTime * _ParticlesPerSecond;
			
			while (_ParticlesToEmit > 1) {
				EmitParticles();
				_ParticlesToEmit--;	
			}
		}
		
		// TODO : Handle more than 1 numParticles
		private function EmitParticles(numParticles:uint = 1):void
		{
			if (!_ParticleSystem)
				return;
			
			var newParticle:hParticle = _ParticleSystem.ActivateParticle();
			
			if (!newParticle)
				return;
			
			newParticle.ResetTranslation(Position.x + (Math.random() * 2 * _StartPositionRange - _StartPositionRange), Position.y + (Math.random() * 2 * _StartPositionRange - _StartPositionRange));
			newParticle.ResetVelocity(_StartVelocity.x + (Math.random() * 2 * _StartVelocityRange.x - _StartVelocityRange.x), _StartVelocity.y + (Math.random() * 2 * _StartVelocityRange.y - _StartVelocityRange.y));
			newParticle.ResetAcceleration(_StartAcceleration.x + (Math.random() * 2 * _StartAccelerationRange.x - _StartAccelerationRange.x), _StartAcceleration.y + (Math.random() * 2 * _StartAccelerationRange.y - _StartAccelerationRange.y));
			newParticle.SetImage(ImageName);
			newParticle.StartAnimation(CurrentAnimation, Math.random() * _AnimationStartTimeRange);
			newParticle.LifeSpan = _ParticleLifespan + (_ParticleLifespanRange * 2 * Math.random() - _ParticleLifespanRange);
		}
		
		public override function Render():void {}
	}
}