package mGameObjects
{
	import HubGaming.*;
	import HubGraphics.*;
	import HubInput.*;
	import flash.ui.*;
	import flash.geom.*;
	
	public class Meteor extends MeteorGameObject
	{
		private var _Shape:String = null;
		private var _PowerupName:String = null;
		private var _ExplosionEmitter:hParticleEmitter;
		
		public function get ExplosionEmitter():hParticleEmitter {return _ExplosionEmitter;}
				
		public function set PowerupName(powerupName:String):void {_PowerupName = powerupName;}
		public function get PowerupName():String {return _PowerupName;}
		public function set Shape(shape:String):void 
		{
			_Shape = shape;
			
			if (_Shape == "small")
				_ExplosionEmitter.ParticlesPerSecond = 50;
			else if (_Shape == "medium")
				_ExplosionEmitter.ParticlesPerSecond = 100;
			else if (_Shape == "large")
				_ExplosionEmitter.ParticlesPerSecond = 150;
			else if (_Shape == "mega")
				_ExplosionEmitter.ParticlesPerSecond = 200;
			
		}
		public function get Shape():String {return _Shape;}
	
		public function Meteor()
		{
			super();
			_ExplosionEmitter = new hParticleEmitter(hGlobalGraphics.ParticleSystem);
			_ExplosionEmitter.SetImage("sparkle_particle");
			_ExplosionEmitter.CurrentAnimation = "sparkle_particle";
			_ExplosionEmitter.AnimationStartTimeRange = 0.02;
			_ExplosionEmitter.StartVelocityRange = new Point(200, 200);
			_ExplosionEmitter.Lifespan = 0.2;
			_ExplosionEmitter.ParticlesPerSecond = 150;
			_ExplosionEmitter.ParticleLifespan = 0.4;
			_ExplosionEmitter.ResetTranslation(Center.x, Center.y);
		}
	}
}