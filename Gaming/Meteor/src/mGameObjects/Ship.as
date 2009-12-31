package mGameObjects
{
	import HubGaming.*;
	import HubGraphics.*;
	import HubInput.*;
	import flash.geom.*;
	
	public class Ship extends MeteorGameObject
	{
		private var _MoveAcceleration:Number = 150;
		private var _MaxSpeed:Number = 400;
		private var _MaxRotationalVelocity:Number = 3.5;
		private var _ExplosionEmitter:hParticleEmitter;
		private var _Sine:Number = 0;
		private var _Cosine:Number = 1;
		private var _Speed:Number = 0;
		private var _InvincibleTime:Number = 5;
		private var _TimeAlive:Number = 0;
		
		private var _NormalImage:String = "ship";
		private var _InvincibleImage:String = "ship";
		private var _Invincible:Boolean = false;
		
		public function set NormalImage(image:String):void {_NormalImage = image;}
		public function set InvincibleImage(image:String):void {_InvincibleImage = image;}
		public function set Invincible(invincible:Boolean):void {_Invincible = invincible;}
		public function get Invincible():Boolean {return (_TimeAlive < _InvincibleTime || _Invincible);}
		public function get Sine():Number {return _Sine;}
		public function get Cosine():Number {return _Cosine;}
		public function get Speed():Number {return _Speed;}
		
		public function Ship()
		{
			super();
			Centered = true;
			_ExplosionEmitter = new hParticleEmitter(hGlobalGraphics.ParticleSystem);
			_ExplosionEmitter.SetImage("sparkle_particle");
			_ExplosionEmitter.CurrentAnimation = "sparkle_particle";
			_ExplosionEmitter.AnimationStartTimeRange = 0.02;
			_ExplosionEmitter.StartVelocity = new Point(0, 2000);
			_ExplosionEmitter.StartVelocityRange = new Point(40, 40);
			_ExplosionEmitter.StartAcceleration = new Point(0, 0);
			_ExplosionEmitter.ParticlesPerSecond = 20;
			_ExplosionEmitter.ParticleLifespan = 1;
		}
		
		public function Reset():void
		{
			_TimeAlive = 0;
			SetImage(_InvincibleImage);
			ResetRotation(0);
			ResetTranslation(320 - Width * 0.5, 240 - Height * 0.5);
			ResetVelocity(0, 0);
		}
		
		public override function Update(elapsedTime:Number):void
		{
			_Sine = Math.sin(Rotation);
			_Cosine = Math.cos(Rotation);
			_Speed = Math.sqrt(Velocity.x * Velocity.x + Velocity.y * Velocity.y);
			_TimeAlive += elapsedTime;
			if (_TimeAlive > 2000)
			 	_TimeAlive -= 1000;
			
			if (Invincible)
				SetImage(_InvincibleImage);
			else
				SetImage(_NormalImage);

			if (hGlobalInput.Keyboard.KeyPressed(hKeyCodes.RIGHT_ARROW) && !hGlobalInput.Keyboard.KeyPressed(hKeyCodes.LEFT_ARROW))
				Rotate(_MaxRotationalVelocity * elapsedTime);
			else if (hGlobalInput.Keyboard.KeyPressed(hKeyCodes.LEFT_ARROW) && !hGlobalInput.Keyboard.KeyPressed(hKeyCodes.RIGHT_ARROW))
				Rotate(-_MaxRotationalVelocity * elapsedTime);
			if (hGlobalInput.Keyboard.KeyPressed(hKeyCodes.UP_ARROW) && !hGlobalInput.Keyboard.KeyPressed(hKeyCodes.DOWN_ARROW)) {
				AddVelocity(_Sine * _MoveAcceleration * elapsedTime, -_Cosine * _MoveAcceleration * elapsedTime);
			} else if (hGlobalInput.Keyboard.KeyPressed(hKeyCodes.DOWN_ARROW) && !hGlobalInput.Keyboard.KeyPressed(hKeyCodes.UP_ARROW)) {
				AddVelocity(-_Sine * _MoveAcceleration * elapsedTime, _Cosine * _MoveAcceleration * elapsedTime);
			}
			
			_ExplosionEmitter.ParticlesPerSecond = 50 * (_Speed / _MaxSpeed);
			_ExplosionEmitter.StartVelocity = new Point(-_Sine * 200, _Cosine * 200);
			_ExplosionEmitter.ResetTranslation(Position.x - 8, Position.y - 8);
			_ExplosionEmitter.Update(elapsedTime);
			
			if (_Speed > _MaxSpeed)
				Velocity.normalize(_MaxSpeed);
			

			super.Update(elapsedTime);
		}
	}
}