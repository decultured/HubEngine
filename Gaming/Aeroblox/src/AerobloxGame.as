package 
{
	import flash.events.*;
	import flash.geom.*;
	import abGameUI.*;
	import abGameObjects.*;
	import HubGraphics.*;
	import HubAudio.*;
	import HubInput.*;
	import HubMath.*;
	
	public class AerobloxGame extends EventDispatcher
	{
		// Static Members : Event Response Strings
		public static var LEVEL_WON:String = "next level";
		public static var GAME_OVER:String = "game over";

		// Private Members
		// Game Objects
		public var _Ball:Ball;
		public var _Paddle:Paddle;
		public var _Blocks:Array;
		public var _PowerupTypes:Array;
		public var _Powerups:Array;
		public var _Cursor:Cursor;

		// Sounds
		public var _PaddleBounceSound:hSound;
		public var _FailSound:hSound;
		public var _Music:hSound;

		// HUD UI
		public var _HUD:abGameHUD;

		// Game State Vars
		private var _StartLevel:String = "level1.xml";
		private var _CurrentLevel:String = "level1.xml";
		private var _NextLevel:String = null;
		private var _Score:Number = 0;
		private var _Balls:Number = 1;
		private var _StartingBalls:Number = 5;
		private var _Cheating:Boolean = false;
		private var _Invincible:Boolean = false;

		// Cheats
		private var _ExtraLivesCheat:Array = [hKeyCodes.I, hKeyCodes.D, hKeyCodes.K, hKeyCodes.F, hKeyCodes.A];
		private var _InvincibleCheat:Array = [hKeyCodes.I, hKeyCodes.D, hKeyCodes.D, hKeyCodes.Q, hKeyCodes.D];
		private var _NextLevelCheat:Array = [hKeyCodes.I, hKeyCodes.D, hKeyCodes.C, hKeyCodes.L, hKeyCodes.E, hKeyCodes.V];
		private var _FireballCheat:Array = [hKeyCodes.I, hKeyCodes.D, hKeyCodes.C, hKeyCodes.L, hKeyCodes.I, hKeyCodes.P];

		// Mutators and Accessors
		public function get Score():Number {return _Score;}
		public function get Balls():Number {return _Balls;}
		public function get NextLevel():String {return _NextLevel;}
		public function set NextLevel(nextLevel:String):void {_NextLevel = nextLevel;}  
		public function get StartLevel():String {return _StartLevel;}  
		public function set StartLevel(startLevel:String):void {_StartLevel = startLevel;}
		public function get CurrentLevel():String {return _CurrentLevel;}  
		public function set CurrentLevel(currentLevel:String):void {_CurrentLevel = currentLevel;}  
		public function get HUD():abGameHUD {return _HUD;}
		
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
		
		public function AddBalls(numBalls:int):Number
		{
			Balls = Balls + numBalls;
			return _Balls;
		}
		
		public function set Balls(numBalls:Number):void
		{
			_Balls = numBalls;
			
			if (_HUD && _HUD.Balls)
				_HUD.Balls.text = String(_Balls);

			if (_Balls < 0) {
				_Balls = _StartingBalls;
				LevelWon();
			}
		}

		/////////////////
		// Constructor //
		/////////////////
      	public function AerobloxGame()
        {
			_HUD = new abGameHUD();

			_PaddleBounceSound = hGlobalAudio.SoundLibrary.GetSoundFromName("ball_hits_paddle");
			_FailSound = hGlobalAudio.SoundLibrary.GetSoundFromName("ball_lost");
			
			Balls = _StartingBalls;
			_Cursor = new Cursor();
			_Ball = new Ball();
			_Paddle = new Paddle();
			_Blocks = new Array();
			_PowerupTypes = new Array();
			_Powerups = new Array();

			Reset();
        }

		//////////////////////////////////
		// Game State Setting Functions //
		//////////////////////////////////
		public function ClearObjects():void 
		{
			hGlobalGraphics.ParticleSystem.DeactivateAllParticles();			
			_Powerups.length = 0;
			_Blocks.length = 0;
		}
		
		public function NewGame():void
		{
			hGlobalGraphics.ParticleSystem.DeactivateAllParticles();			
			_Powerups.length = 0;
			Score = 0;
			Balls = _StartingBalls;

			var blocksLength:uint = _Blocks.length;
			for (var i:uint = 0; i < blocksLength; i++) {
				if (!_Blocks[i] || !_Blocks[i] is Block)
					continue;
				_Blocks[i].Active = true;
				_Blocks[i].Visible = true;
			}

			Reset();
		}

		public function Reset():void
		{
			_Powerups.length = 0;
			_Ball.Reset();
			_Paddle.ResetTranslation(320 - _Paddle.Width * 0.5, _Paddle.DefaultYPosition)
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
		public function AddBlock(imageName:String, shape:String, xPos:Number, yPos:Number, width:Number, height:Number, currentFrame:uint, powerupName:String):void
		{
			var newBlock:Block = new Block();
			newBlock.Width = width;
			newBlock.Height = height;
			newBlock.CurrentFrame = currentFrame;
			newBlock.SetImage(imageName);
			newBlock.Translate(xPos, yPos);
			newBlock.PowerupName = powerupName;
			_Blocks.push(newBlock);
		}
		
		public function AddPowerup(imageName:String, type:String, width:Number, height:Number, currentFrame:uint):void
		{
			var newPowerup:Powerup = new Powerup();
			newPowerup.Width = width;
			newPowerup.Height = height;
			newPowerup.CurrentFrame = currentFrame;
			newPowerup.SetImage(imageName);
			newPowerup.Type = type;
			_PowerupTypes.push(newPowerup);
		}
		
		public function AddPaddle(imageName:String, width:Number, height:Number):void
		{
			_Paddle.SetImage(imageName);
			_Paddle.Width = width;
			_Paddle.Height = height;
		}
		
		public function AddBall(imageName:String, width:Number, height:Number):void
		{
			_Ball.SetImage(imageName);
			_Ball.Width = width;
			_Ball.Height = height;
		}

		//////////////////////
		// Powerup Handling //
		//////////////////////
		public function ClonePowerupByType(type:String, xPos:Number, yPos:Number):void
		{
			var powerupsLength:uint = _PowerupTypes.length;
			for (var i:uint = 0; i < powerupsLength; i++) {
				if (_PowerupTypes[i] && _PowerupTypes[i].Type == type) {
					var newPowerup:Powerup = new Powerup();
					newPowerup.Width = _PowerupTypes[i].Width;
					newPowerup.Height = _PowerupTypes[i].Height;
					newPowerup.CurrentFrame = _PowerupTypes[i].CurrentFrame;
					newPowerup.SetImage(_PowerupTypes[i].GetImageName());
					newPowerup.Type = type;
					newPowerup.Translate(xPos, yPos);
					_Powerups.push(newPowerup);
					break;
				}
			}
		}
		
		public function ApplyPowerup(powerup:Powerup):void
		{
			if (powerup.Type == "slow_ball") {
				_Ball.SlowDown();
			} else if (powerup.Type == "fast_ball") {
				_Ball.SpeedUp();
			}
		}

		public function Update(elapsedTime:Number):void
		{
			hGlobalAudio.PlayMusic();
			if (hGlobalInput.Keyboard.KeySequenceEntered(_ExtraLivesCheat)) {
				Balls = Balls + 50;
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
		
			_Ball.Update(elapsedTime);
			_Paddle.Update(elapsedTime);

			for (var i:uint = 0; i < _Powerups.length; i++) {
				if (!_Powerups[i] || !_Powerups[i] is Powerup || !_Powerups[i].Active)
					continue;
				_Powerups[i].Update(elapsedTime);
				
				if (_Paddle.ObjectRectanglesCollide(_Powerups[i])) {
					_Powerups[i].Active = false;
					_Powerups[i].Visible = false;
					Score += 250;
					ApplyPowerup(_Powerups[i]);
					_FailSound.Play();
				}
			}

			// Collide Ball with Blocks
			var collisionBlock:Block = null;
			var blocksLength:uint = _Blocks.length;
			var activeBlocks:uint = 0;
			for (i = 0; i < blocksLength; i++) {
				if (!_Blocks[i] || !_Blocks[i] is Block)
				 	continue;
				if (!_Blocks[i].Active && _Blocks[i].ExplosionEmitter) {
					if (_Blocks[i].ExplosionEmitter.IsAlive) {
						_Blocks[i].ExplosionEmitter.StartPositionRange = _Blocks[i].Height * 0.5;
						_Blocks[i].ExplosionEmitter.ResetTranslation(_Blocks[i].CollisionPoint.x, _Blocks[i].CollisionPoint.y);
						_Blocks[i].ExplosionEmitter.Update(elapsedTime);
					}
					continue;
				}
					
				activeBlocks++;
				
				_Blocks[i].Update(elapsedTime);
				_Blocks[i].CollideWithLine(_Ball.PreviousCenter, _Ball.Center);

				if (_Blocks[i].Collided == true) {
					if (!collisionBlock || collisionBlock.DistanceSquaredToCollisionPoint(_Ball.PreviousCenter) > _Blocks[i].DistanceSquaredToCollisionPoint(_Ball.PreviousCenter))
						collisionBlock = _Blocks[i];
				}
			}

			if (collisionBlock) {
				_Ball.ResetTranslation(collisionBlock.CollisionPoint.x - _Ball.Width * 0.5, collisionBlock.CollisionPoint.y - _Ball.Height * 0.5);

				if (collisionBlock.CollisionSide == Block.TOP_COLLISION) {
					_Ball.ResetVelocity(_Ball.Velocity.x, -Math.abs(_Ball.Velocity.y));
				} else if (collisionBlock.CollisionSide == Block.RIGHT_COLLISION) {
					_Ball.ResetVelocity(Math.abs(_Ball.Velocity.x), _Ball.Velocity.y);
				} else if (collisionBlock.CollisionSide == Block.BOTTOM_COLLISION) {
					_Ball.ResetVelocity(_Ball.Velocity.x, Math.abs(_Ball.Velocity.y));
				} else if (collisionBlock.CollisionSide == Block.LEFT_COLLISION) {
					_Ball.ResetVelocity(-Math.abs(_Ball.Velocity.x), _Ball.Velocity.y);
				}
				
				collisionBlock.Hit();
				
				activeBlocks--;
				Score += 100;
				
				ClonePowerupByType(collisionBlock.PowerupName, collisionBlock.Left, collisionBlock.Bottom);
			}
			
			// End Level if No More Blocks
			if (activeBlocks < 1)
				LevelWon();
			
			//Collide Ball With Paddle
			if (hCollision.PointCollidesWithRect(_Ball.Center.x, _Ball.Center.y, _Paddle.Left, _Paddle.Top, _Paddle.Right, _Paddle.Bottom))
			{
				_Ball.Position.y = _Paddle.Position.y - _Ball.Height;
				
				_Ball.AddVelocity((_Ball.Center.x - _Paddle.Center.x) * 8, 0);
				_Ball.ResetVelocity(_Ball.Velocity.x, -Math.abs(_Ball.Velocity.y));
				if (_Ball.Velocity.x > 220)
					_Ball.ResetVelocity(220, _Ball.Velocity.y);
				if (_Ball.Velocity.x < -220)
					_Ball.ResetVelocity(-220, _Ball.Velocity.y);
				_Ball.Velocity.normalize(_Ball.Speed);
				_PaddleBounceSound.Play();
			}
			
			//Reset if Ball Hits Bottom
			if (_Ball.Bottom > hGlobalGraphics.View.Height) {
				if (!_Invincible) {
					Balls -= 1;
					_FailSound.Play();	
					Reset();
				} else {
					_Ball.ResetTranslation(_Ball.Position.x, Math.abs(_Ball.Position.y));
					_Ball.ResetVelocity(_Ball.Velocity.x, -Math.abs(_Ball.Velocity.y));
				}
			}

			hGlobalGraphics.ParticleSystem.Update(elapsedTime);
		}
		
		public function Render():void
		{
			hGlobalGraphics.ParticleSystem.Render();
			
			var blocksLength:uint = _Blocks.length;
			for (var i:uint = 0; i < blocksLength; i++) {
				if (_Blocks[i] && _Blocks[i] is Block && _Blocks[i].Visible)
					_Blocks[i].Render();
			}
			
			for (i = 0; i < _Powerups.length; i++) {
				if (_Powerups[i])
					_Powerups[i].Render();
			}
			
			_Ball.Render();
			_Paddle.Render();
		}
	}
}