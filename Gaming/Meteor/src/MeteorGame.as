package 
{
	import flash.events.*;
	import flash.geom.*;
	import mGameUI.*;
	import mGameObjects.*;
	import HubGraphics.*;
	import HubAudio.*;
	import HubInput.*;
	import HubMath.*;
	
	public class MeteorGame extends EventDispatcher
	{
		// Static Members : Event Response Strings
		public static var LEVEL_WON:String = "next level";
		public static var GAME_OVER:String = "game over";

		// Private Members
		// Game Objects
		public var _Ship:Ship;

		public var _SmallMeteors:Array = new Array();
		public var _MediumMeteors:Array = new Array();
		public var _LargeMeteors:Array = new Array();
		public var _MegaMeteors:Array = new Array();

		public var _ActiveMeteors:Array = new Array();

		public var _ProjectileTypes:Array = new Array();
		public var _Projectiles:Array = new Array();

		// Sounds
		public var _ExplosionSound:hSound;
		public var _LostShipSound:hSound;
		public var _FireSound:hSound;

		// HUD UI
		public var _HUD:mGameHUD;

		// Game State Vars
		private var _Level:Number = 0;
		private var _MeteorStartMaxSpeed:Number = 150;
		private var _MeteorMaxSpeed:Number = 150;
		private var _SinceLastProjectile:Number = 1000;
		private var _ProjectileTime:Number = 0.25;
		private var _Resources:String = null;
		private var _Score:Number = 0;
		private var _Ships:Number = 1;
		private var _Shields:Number = 100;
		private var _ShieldLossRate:Number = 100;
		private var _StartingShips:Number = 3;
		private var _Cheating:Boolean = false;
		private var _Invincible:Boolean = false;

		// Cheats
		private var _ExtraLivesCheat:Array = [hKeyCodes.I, hKeyCodes.D, hKeyCodes.K, hKeyCodes.F, hKeyCodes.A];
		private var _InvincibleCheat:Array = [hKeyCodes.I, hKeyCodes.D, hKeyCodes.D, hKeyCodes.Q, hKeyCodes.D];
		private var _FireFastCheat:Array = [hKeyCodes.I, hKeyCodes.D, hKeyCodes.B, hKeyCodes.E, hKeyCodes.H, hKeyCodes.O, hKeyCodes.L, hKeyCodes.D, hKeyCodes.S];

		// Mutators and Accessors
		public function get Score():Number {return _Score;}
		public function get Ships():Number {return _Ships;}
		public function get Shields():Number {return _Shields;}
		public function get Resources():String {return _Resources;}  
		public function set Resources(resources:String):void {_Resources = resources;}
		public function get HUD():mGameHUD {return _HUD;}
		
		public function AddScore(value:Number):Number
		{
			Score = Score + value;
			return Score;
		}

		public function set Score(value:Number):void
		{
			if (!_Cheating)
				_Score = value;
			else
				_Score = 0;
				
			if (_HUD && _HUD.Score) {
				_HUD.Score.text = String(_Score);
			}
		}
		
		public function AddShips(numShips:int):Number
		{
			Ships = Ships + numShips;
			return _Ships;
		}
		
		public function set Ships(numShips:Number):void
		{
			_Ships = numShips;
			
			if (_HUD && _HUD.Ships)
				_HUD.Ships.text = String(_Ships);

			if (_Ships < 0) {
				_Ships = _StartingShips;
				GameOver();
			}
		}

		public function set Shields(numShields:Number):void
		{
			_Shields = numShields;
			
			if (_Shields < 0)
				_Shields = 0;
			if (_Shields > 100)
				_Shields = 100;

			if (_HUD && _HUD.Shields)
				_HUD.Shields.setProgress(_Shields, 100);
		}

		/////////////////
		// Constructor //
		/////////////////
      	public function MeteorGame()
        {
			_HUD = new mGameHUD();

			Ships = _StartingShips;
			_Ship = new Ship();
			
			_ExplosionSound = hGlobalAudio.SoundLibrary.GetSoundFromName("explosion");
			_LostShipSound = hGlobalAudio.SoundLibrary.GetSoundFromName("lost_ship");
			_FireSound = hGlobalAudio.SoundLibrary.GetSoundFromName("fire");

			Reset();
        }

		//////////////////////////////////
		// Game State Setting Functions //
		//////////////////////////////////
		public function ClearObjects():void 
		{
			hGlobalGraphics.ParticleSystem.DeactivateAllParticles();			
			_Projectiles.length = 0;
			_ActiveMeteors.length = 0;
		}
		
		public function NewGame():void
		{
			
			Score = 0;
			_MeteorMaxSpeed = _MeteorStartMaxSpeed;
			Ships = _StartingShips;
			NewLevel();
		}
		
		public function NewLevel():void
		{
			_Level += 1;
			Ships += 2;
			if (_HUD && _HUD.Level) {
				_HUD.Level.text = String(_Level);
			}
			_MeteorMaxSpeed = _MeteorStartMaxSpeed + _Level * 25;
			ClearObjects();
			CreateMeteors();
			Reset();
		}
		
		public function CreateMeteors():void
		{
			// Create Some Large Meteors
			if (_LargeMeteors.length) {
				var LargeSpawnNumber:uint = uint(((_Level + 1) / 3) + 1);
				for (var i:uint = 0; i < LargeSpawnNumber; i++)
				{
					CloneMeteor(_LargeMeteors[uint(Math.random() * (_LargeMeteors.length - 1))], Math.random() * 640, Math.random() * 480, Math.random() * _MeteorMaxSpeed - _MeteorMaxSpeed * 0.5, Math.random() * _MeteorMaxSpeed - _MeteorMaxSpeed * 0.5);
				}
			}
			
			if (_MediumMeteors.length) {
				var MediumSpawnNumber:uint = uint(_Level / 7);
				for (i = 0; i < MediumSpawnNumber; i++)
				{
					CloneMeteor(_MediumMeteors[uint(Math.random() * (_MediumMeteors.length - 1))], Math.random() * 640, Math.random() * 480, Math.random() * _MeteorMaxSpeed - _MeteorMaxSpeed * 0.5, Math.random() * _MeteorMaxSpeed - _MeteorMaxSpeed * 0.5);
				}
			}
			
			// Create a Mega Meteor
			if (_MegaMeteors.length) {
				var MegaSpawnNumber:uint = uint((_Level / 5) + 1);
				for (i = 0; i < MegaSpawnNumber; i++)
				{
					CloneMeteor(_MegaMeteors[uint(Math.random() * (_MegaMeteors.length - 1))], Math.random() * 640, Math.random() * 480, Math.random() * _MeteorMaxSpeed - _MeteorMaxSpeed * 0.5, Math.random() * _MeteorMaxSpeed - _MeteorMaxSpeed * 0.5);
				}
			}
		}

		public function SpawnMeteors(typeArray:Array, num:uint, posX:Number, posY:Number):void
		{
			if (typeArray.length) {
				for (var i:uint = 0; i < num; i++)
				{
					CloneMeteor(typeArray[uint(Math.random() * (typeArray.length - 1))], posX, posY, Math.random() * _MeteorMaxSpeed - _MeteorMaxSpeed * 0.5, Math.random() * _MeteorMaxSpeed - _MeteorMaxSpeed * 0.5);
				}
			}
		}

		public function Reset():void
		{
			hGlobalGraphics.ParticleSystem.DeactivateAllParticles();			
			_Projectiles.length = 0;
			_Ship.Reset();
		}

		//////////////////////////////////
		// Show and Display the Game UI //
		//////////////////////////////////
		public function ShowHUD():void {if (hGlobalGraphics.View.ViewImage && _HUD) hGlobalGraphics.View.ViewImage.addChild(_HUD);}
        public function HideHUD():void {if (hGlobalGraphics.View.ViewImage && _HUD) hGlobalGraphics.View.ViewImage.removeChild(_HUD);}

		///////////////////////
		// Event Dispatchers //
		///////////////////////
		public function LevelWon():void
		{
			dispatchEvent(new Event(LEVEL_WON));			
		}

		public function GameOver():void
		{
			dispatchEvent(new Event(GAME_OVER));			
		}

		////////////////////////////////////////////
		// Object Creation - Used by Level Loader //
		////////////////////////////////////////////
		public function AddMeteor(imageName:String, shape:String, width:Number, height:Number, currentFrame:uint, powerupName:String = null):void
		{
			var newMeteor:Meteor = new Meteor();
			newMeteor.Shape = shape;
			newMeteor.Width = width;
			newMeteor.Height = height;
			newMeteor.CurrentFrame = currentFrame;
			newMeteor.SetImage(imageName);
			newMeteor.PowerupName = powerupName;
			
			if (newMeteor.Shape == "small")
				_SmallMeteors.push(newMeteor);
			else if (newMeteor.Shape == "medium")
				_MediumMeteors.push(newMeteor);
			else if (newMeteor.Shape == "large")
				_LargeMeteors.push(newMeteor);
			else if (newMeteor.Shape == "mega")
				_MegaMeteors.push(newMeteor);	
		}
		
		public function AddProjectile(imageName:String, type:String, width:Number, height:Number):void
		{
			var newProjectile:Projectile = new Projectile();
			newProjectile.Type = type;
			newProjectile.Width = width;
			newProjectile.Height = height;
			newProjectile.SetImage(imageName);
			_ProjectileTypes.push(newProjectile);
		}
		
		public function AddShip(imageName:String, invincibleImageName:String, width:Number, height:Number):void
		{
			_Ship.SetImage(imageName);
			_Ship.NormalImage = imageName;
			_Ship.InvincibleImage = invincibleImageName;
			_Ship.Width = width;
			_Ship.Height = height;
			_Ship.Translate(hGlobalGraphics.View.Width * 0.5 - width * 0.5, hGlobalGraphics.View.Height * 0.5 - height * 0.5);
		}

		//////////////////////
		// Projectile Handling //
		//////////////////////
		public function CloneProjectileByType(type:String, xPos:Number, yPos:Number, velX:Number, velY:Number):void
		{
			var powerupsLength:uint = _ProjectileTypes.length;
			for (var i:uint = 0; i < powerupsLength; i++) {
				if (_ProjectileTypes[i] && _ProjectileTypes[i].Type == type) {
					var newProjectile:Projectile = new Projectile();
					newProjectile.Width = _ProjectileTypes[i].Width;
					newProjectile.Height = _ProjectileTypes[i].Height;
					newProjectile.CurrentFrame = _ProjectileTypes[i].CurrentFrame;
					newProjectile.SetImage(_ProjectileTypes[i].GetImageName());
					newProjectile.Type = type;
					newProjectile.ResetTranslation(xPos, yPos);
					newProjectile.ResetVelocity(velX, velY);
					_Projectiles.push(newProjectile);
					break;
				}
			}
		}
		
		public function CloneMeteor(meteor:Meteor, xPos:Number, yPos:Number, velX:Number, velY:Number):void
		{
			var newMeteor:Meteor = new Meteor();
			newMeteor.Width = meteor.Width;
			newMeteor.Height = meteor.Height;
			newMeteor.CurrentFrame = meteor.CurrentFrame;
			newMeteor.SetImage(meteor.GetImageName());
			newMeteor.Shape = meteor.Shape;
			newMeteor.Translate(xPos, yPos);
			newMeteor.AddVelocity(velX, velY);
			_ActiveMeteors.push(newMeteor);
		}
		
		public function Update(elapsedTime:Number):void
		{
			var i:uint = 0;
			var j:uint = 0;
			
			hGlobalAudio.PlayMusic();
			
			if (hGlobalInput.Keyboard.KeySequenceEntered(_ExtraLivesCheat)) {
				Ships = Ships + 50;
				_Cheating = true;
			}
			
			if (hGlobalInput.Keyboard.KeySequenceEntered(_InvincibleCheat)) {
				_Invincible = !_Invincible;
				_Cheating = true;
			}

			if (hGlobalInput.Keyboard.KeySequenceEntered(_FireFastCheat)) {
				_ProjectileTime = 0.025;
				_Cheating = true;
			}
		
			_SinceLastProjectile += elapsedTime;
			if (hGlobalInput.Keyboard.KeyPressed(hKeyCodes.SPACEBAR))
			{
				if (_SinceLastProjectile > _ProjectileTime) 
				{
					_FireSound.Play();
					_SinceLastProjectile = 0;
					var ProjVel:Point = new Point(_Ship.Sine, -_Ship.Cosine);
					ProjVel.normalize(400);
					CloneProjectileByType("photon", _Ship.Position.x - 7, _Ship.Position.y - 7, ProjVel.x, ProjVel.y);
				}
			}

			if (hGlobalInput.Keyboard.KeyPressed(hKeyCodes.S) && _Shields) {
				_Ship.Invincible = true;
				Shields = Shields - _ShieldLossRate * elapsedTime;
			} else {
				_Ship.Invincible = false;	
			}
			
			
			_Ship.Update(elapsedTime);

			for (i = 0; i < _Projectiles.length; i++) {
				if (!_Projectiles[i] || !_Projectiles[i] is Projectile)
					continue;

				if (!_Projectiles[i].Active) {
					_Projectiles.splice(i, 1);
					i--;
					continue;
				}
				
				for (j = 0; j < _ActiveMeteors.length; j++) {
					if (!_ActiveMeteors[j] || !_ActiveMeteors[j] is Meteor || !_ActiveMeteors[j].Active)
					 	continue;

					if (_Projectiles[i].ObjectRectanglesCollide(_ActiveMeteors[j]))
					{
						// Spawn Smaller and Score
						if (_ActiveMeteors[j].Shape == "small") {
							Score = Score + 250;
						}
						else if (_ActiveMeteors[j].Shape == "medium") {
							SpawnMeteors(_SmallMeteors, 3, _ActiveMeteors[j].Position.x, _ActiveMeteors[j].Position.y);
							Score = Score + 150;
						}
						else if (_ActiveMeteors[j].Shape == "large") {
							SpawnMeteors(_MediumMeteors, 3, _ActiveMeteors[j].Position.x, _ActiveMeteors[j].Position.y);
							Score = Score + 75;
						}
						else if (_ActiveMeteors[j].Shape == "mega") {
							SpawnMeteors(_LargeMeteors, 2, _ActiveMeteors[j].Position.x, _ActiveMeteors[j].Position.y);
							Score = Score + 25;
						}

						_ExplosionSound.Play();
						_ActiveMeteors[j].Active = false;
						_ActiveMeteors[j].Visible = false;
						_Projectiles[i].Active = false;
						break;
					}
				}
				
				_Projectiles[i].Update(elapsedTime);
			}

			var meteorsLength:uint = _ActiveMeteors.length;
			var activeMeteors:uint = 0;
			for (i = 0; i < meteorsLength; i++) {
				if (!_ActiveMeteors[i] || !_ActiveMeteors[i] is Meteor)
				 	continue;
				
				if (!_ActiveMeteors[i].Active) {
					if (_ActiveMeteors[i].ExplosionEmitter && _ActiveMeteors[i].ExplosionEmitter.IsAlive) {
						_ActiveMeteors[i].ExplosionEmitter.StartPositionRange = _ActiveMeteors[i].Height * 0.5;
						_ActiveMeteors[i].ExplosionEmitter.ResetTranslation(_ActiveMeteors[i].Position.x, _ActiveMeteors[i].Position.y);
						_ActiveMeteors[i].ExplosionEmitter.ResetVelocity(_ActiveMeteors[i].Velocity.x, _ActiveMeteors[i].Velocity.y);
						_ActiveMeteors[i].ExplosionEmitter.Update(elapsedTime);
					} else {
						_ActiveMeteors.splice(i, 1);
						i--;
						continue;
					}
				}
				
					
				activeMeteors++;
				
				if (_Ship.ObjectRectanglesCollide(_ActiveMeteors[i]))
				{
					if (!_Invincible && !_Ship.Invincible) {
						_LostShipSound.Play();
					
						Ships -= 1;
						Reset();
					}
				}
				
				_ActiveMeteors[i].Update(elapsedTime);
			}

			// End Level if No More Meteors
			if (activeMeteors < 1)
				LevelWon();
			
			hGlobalGraphics.ParticleSystem.Update(elapsedTime);
		}
		
		public function Render():void
		{
			hGlobalGraphics.ParticleSystem.Render();
			
			var meteorsLength:uint = _ActiveMeteors.length;
			for (var i:uint = 0; i < meteorsLength; i++) {
				if (_ActiveMeteors[i] && _ActiveMeteors[i] is Meteor && _ActiveMeteors[i].Visible)
					_ActiveMeteors[i].Render();
			}
			
			for (i = 0; i < _Projectiles.length; i++) {
				if (_Projectiles[i])
					_Projectiles[i].Render();
			}
			
			_Ship.Render();
		}
	}
}