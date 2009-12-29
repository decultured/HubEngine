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
		public var _MeteorTypes:Array;
		public var _Meteors:Array;
		public var _ProjectileTypes:Array;
		public var _Projectiles:Array;

		// HUD UI
		public var _HUD:mGameHUD;

		// Game State Vars
		private var _Resources:String = null;
		private var _Score:Number = 0;
		private var _Ships:Number = 1;
		private var _StartingShips:Number = 5;
		private var _Cheating:Boolean = false;
		private var _Invincible:Boolean = false;

		// Cheats
		private var _ExtraLivesCheat:Array = [hKeyCodes.I, hKeyCodes.D, hKeyCodes.K, hKeyCodes.F, hKeyCodes.A];
		private var _InvincibleCheat:Array = [hKeyCodes.I, hKeyCodes.D, hKeyCodes.D, hKeyCodes.Q, hKeyCodes.D];
		private var _NextLevelCheat:Array = [hKeyCodes.I, hKeyCodes.D, hKeyCodes.C, hKeyCodes.L, hKeyCodes.E, hKeyCodes.V];

		// Mutators and Accessors
		public function get Score():Number {return _Score;}
		public function get Ships():Number {return _Ships;}
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
				LevelWon();
			}
		}

		/////////////////
		// Constructor //
		/////////////////
      	public function MeteorGame()
        {
			_HUD = new mGameHUD();

			Ships = _StartingShips;
			_Ship = new Ship();
			_Meteors = new Array();
			_ProjectileTypes = new Array();
			_Projectiles = new Array();

			Reset();
        }

		//////////////////////////////////
		// Game State Setting Functions //
		//////////////////////////////////
		public function ClearObjects():void 
		{
			hGlobalGraphics.ParticleSystem.DeactivateAllParticles();			
			_Projectiles.length = 0;
			_Meteors.length = 0;
		}
		
		public function NewGame():void
		{
			ClearObjects();
			Score = 0;
			Ships = _StartingShips;

			Reset();
		}

		public function Reset():void
		{
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
		public function AddMeteor(imageName:String, type:String, shape:String, width:Number, height:Number, currentFrame:uint, powerupName:String):void
		{
			var newMeteor:Meteor = new Meteor();
			newMeteor.Width = width;
			newMeteor.Height = height;
			newMeteor.CurrentFrame = currentFrame;
			newMeteor.SetImage(imageName);
			newMeteor.PowerupName = powerupName;
			_MeteorTypes.push(newMeteor);
		}
		
		public function AddProjectile(imageName:String, type:String, width:Number, height:Number, currentFrame:uint):void
		{
			var newProjectile:Projectile = new Projectile();
			newProjectile.Width = width;
			newProjectile.Height = height;
			newProjectile.CurrentFrame = currentFrame;
			newProjectile.SetImage(imageName);
			newProjectile.Type = type;
			_ProjectileTypes.push(newProjectile);
		}
		
		public function AddShip(imageName:String, width:Number, height:Number):void
		{
			_Ship.SetImage(imageName);
			_Ship.Width = width;
			_Ship.Height = height;
		}

		//////////////////////
		// Projectile Handling //
		//////////////////////
		public function CloneProjectileByType(type:String, xPos:Number, yPos:Number):void
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
					newProjectile.Translate(xPos, yPos);
					_Projectiles.push(newProjectile);
					break;
				}
			}
		}
		
		public function ApplyProjectile(powerup:Projectile):void
		{
			/*if (powerup.Type == "slow_ball") {
				_Ship.SlowDown();
			} else if (powerup.Type == "fast_ball") {
				_Ship.SpeedUp();
			}*/
		}

		public function Update(elapsedTime:Number):void
		{
			hGlobalAudio.PlayMusic();
			
			if (hGlobalInput.Keyboard.KeySequenceEntered(_ExtraLivesCheat)) {
				Ships = Ships + 50;
				_Cheating = true;
			}
			
			if (hGlobalInput.Keyboard.KeySequenceEntered(_InvincibleCheat)) {
				_Invincible = !_Invincible;
				_Cheating = true;
			}

			if (hGlobalInput.Keyboard.KeySequenceEntered(_NextLevelCheat)) {
				LevelWon();
				_Cheating = true;
			}
		
			_Ship.Update(elapsedTime);

			for (var i:uint = 0; i < _Projectiles.length; i++) {
				if (!_Projectiles[i] || !_Projectiles[i] is Projectile || !_Projectiles[i].Active)
					continue;
				_Projectiles[i].Update(elapsedTime);
			}

			var blocksLength:uint = _Meteors.length;
			var activeMeteors:uint = 0;
			for (i = 0; i < blocksLength; i++) {
				if (!_Meteors[i] || !_Meteors[i] is Meteor)
				 	continue;
					
				activeMeteors++;
				
				_Meteors[i].Update(elapsedTime);
			}

			// End Level if No More Meteors
			if (activeMeteors < 1)
				LevelWon();
			
			hGlobalGraphics.ParticleSystem.Update(elapsedTime);
		}
		
		public function Render():void
		{
			hGlobalGraphics.ParticleSystem.Render();
			
			var meteorsLength:uint = _Meteors.length;
			for (var i:uint = 0; i < meteorsLength; i++) {
				if (_Meteors[i] && _Meteors[i] is Meteor && _Meteors[i].Visible)
					_Meteors[i].Render();
			}
			
			for (i = 0; i < _Projectiles.length; i++) {
				if (_Projectiles[i])
					_Projectiles[i].Render();
			}
			
			_Ship.Render();
		}
	}
}