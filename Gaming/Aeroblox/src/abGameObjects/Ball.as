package abGameObjects
{
	import HubGaming.*;
	import HubGraphics.*;
	import HubAudio.*;
	import flash.geom.*;
	
	public class Ball extends hGameObject
	{
		private var _Speed:Number = 220
		private var _DefaultSpeed:Number = 220;
		private var _SpeedVariation:Number = 75;
		private var _MaxVelocity:Number = 370;
		private var _MinVelocity:Number = 70;
		private var _WallBounceSound:hSound;
		
		private var _SpeedChangeDuration:Number = 10;
		private var _SpeedChangeElapsed:Number = 0;
		
		private var _ExplosionEmitter:hParticleEmitter;
		
		public function get Speed():Number {return _Speed;}
		
		public function Ball()
		{
			super();
			_WallBounceSound = hGlobalAudio.SoundLibrary.AddSound("ball_hits_wall");
			_ExplosionEmitter = new hParticleEmitter(hGlobalGraphics.ParticleSystem);
			_ExplosionEmitter.SetImage("explosion_particle");
			_ExplosionEmitter.CurrentAnimation = "explosion_particle";
			_ExplosionEmitter.AnimationStartTimeRange = 0.02;
			_ExplosionEmitter.StartVelocityRange = new Point(20, 20);
			_ExplosionEmitter.StartAcceleration = new Point(0, 75);
			_ExplosionEmitter.AnimationStartTimeRange = 0.2;
			_ExplosionEmitter.ParticlesPerSecond = 20;
			_ExplosionEmitter.ParticleLifespan = 1;

			Reset();
		}

		public function Reset():void
		{
			_Speed = _DefaultSpeed;
			ResetTranslation(325, 380);
			ResetVelocity(0, -_Speed);
			Velocity.normalize(_Speed);
		}
		
		public function SpeedUp():void
		{
			_SpeedChangeElapsed = 0;
			_Speed += _SpeedVariation;
			
			if (_Speed > _MaxVelocity)
				_Speed = _MaxVelocity;
			
			Velocity.normalize(_Speed);
		}
		
		public function SlowDown():void
		{
			_SpeedChangeElapsed = 0;
			_Speed -= _SpeedVariation;

			if (_Speed < _MinVelocity)
				_Speed = _MinVelocity;

			Velocity.normalize(_Speed);
		}
		
		public override function Update(elapsedTime:Number):void
		{
			_SpeedChangeElapsed += elapsedTime;
			
			if (_Speed != _DefaultSpeed && _SpeedChangeElapsed > _SpeedChangeDuration) {
				_Speed = _DefaultSpeed;
				Velocity.normalize(_Speed);
			}
			
			_ExplosionEmitter.ResetTranslation(Position.x, Position.y);
			_ExplosionEmitter.Update(elapsedTime);
			
			super.Update(elapsedTime);
			
			if (Position.x < 0) {
				Position.x = Math.abs(Position.x);
				ResetVelocity(Math.abs(Velocity.x), Velocity.y);
				_WallBounceSound.Play();
			}

			if (Position.x > hGlobalGraphics.View.Width - Width) {
				Position.x = (hGlobalGraphics.View.Width - Width) * 2 - Position.x;
				ResetVelocity(-Math.abs(Velocity.x), Velocity.y);
				_WallBounceSound.Play();
			}

			if (Position.y < 0) {
				Position.y = Math.abs(Position.y);
				ResetVelocity(Velocity.x, Math.abs(Velocity.y));
				_WallBounceSound.Play();
			}
		}
	}
}