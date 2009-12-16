package 
{
	import bbGameObjects.*;
	import HubGraphics.*;
	import HubAudio.*;
	import HubMath.*;
	import flash.geom.*;
	import bbGameUI.*;
	import nl.demonsters.debugger.MonsterDebugger;
	
	public class BrickBreakerGame 
	{
		public var _Ball:Ball;
		public var _Paddle:Paddle;
		public var _Blocks:Array;
		public var _PowerupTypes:Array;
		public var _Powerups:Array;
		public var _Cursor:Cursor;

		public var _PaddleBounceSound:hSound;
		public var _FailSound:hSound;
		public var _Music:hSound;
		public var _HUD:bbGameHUD;
		
		private var _StartLevel:String = "level1.xml";
		private var _CurrentLevel:String = "level1.xml";
		private var _NextLevel:String = null;
		private var _Score:Number = 0;
		private var _Balls:Number = 3;
		private var _StartingBalls:Number = 3;
		private var _GameOver:Boolean = false;
		private var _LevelWon:Boolean = false;

		public function get Score():Number {return _Score;}
		public function get GameOver():Boolean {return _GameOver;}
		public function get LevelWon():Boolean {return _LevelWon;}
		public function get NextLevel():String {return _NextLevel;}  
		public function set NextLevel(nextLevel:String):void {_NextLevel = nextLevel;}  
		public function get StartLevel():String {return _StartLevel;}  
		public function set StartLevel(startLevel:String):void {_StartLevel = startLevel;}
		public function get CurrentLevel():String {return _CurrentLevel;}  
		public function set CurrentLevel(currentLevel:String):void {_CurrentLevel = currentLevel;}  
		public function get HUD():bbGameHUD {return _HUD;}

		public function ShowHUD():void {hGlobalGraphics.View.ViewImage.addChild(_HUD);}
		public function HideHUD():void {hGlobalGraphics.View.ViewImage.removeChild(_HUD);}
		
      	public function BrickBreakerGame()
        {
			_HUD = new bbGameHUD();

			_PaddleBounceSound = hGlobalAudio.SoundLibrary.GetSoundFromName("ball_hits_paddle");
			_FailSound = hGlobalAudio.SoundLibrary.GetSoundFromName("ball_lost");
			
			_Balls = _StartingBalls;
			_Cursor = new Cursor();
			_Ball = new Ball();
			_Paddle = new Paddle();
			_Blocks = new Array();
			_PowerupTypes = new Array();
			_Powerups = new Array();

			Reset();
        }

		public function ClearObjects():void
		{
			var blocksLength:uint = _Blocks.length;
			for (var i:uint = 0; i < blocksLength; i++) {
				if (!_Blocks[i] || !_Blocks[i] is Block)
					continue;
				delete _Blocks[i];
			}
			
			_Blocks = new Array();
			_LevelWon = false;
		}

		public function NewGame():void
		{
			var blocksLength:uint = _Blocks.length;
			for (var i:uint = 0; i < blocksLength; i++) {
				if (!_Blocks[i] || !_Blocks[i] is Block)
					continue;
				_Blocks[i].Active = true;
				_Blocks[i].Visible = true;
			}
			
			_GameOver = false;
			_LevelWon = false;
			_Score = 0;
			_Balls = _StartingBalls;

			Reset()
		}

		public function Reset():void
		{
			if (_HUD && _HUD.Balls && _HUD.Score) {
				_HUD.Balls.text = String(_Balls);
				_HUD.Score.text = String(_Score);
			}
			
			_Ball.Reset();
			_Paddle.ResetTranslation(320 - _Paddle.Width * 0.5, _Paddle.DefaultYPosition)
		}
		
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
			_Ball.Update(elapsedTime);
			_Paddle.Update(elapsedTime);

			for (var i:uint = 0; i < _Powerups.length; i++) {
				if (!_Powerups[i] || !_Powerups[i] is Powerup || !_Powerups[i].Active)
					continue;
				_Powerups[i].Update(elapsedTime);
				
				if (_Paddle.ObjectRectanglesCollide(_Powerups[i])) {
					_Powerups[i].Active = false;
					_Powerups[i].Visible = false;
					ApplyPowerup(_Powerups[i]);
					_FailSound.Play();
				}
			}

			// Collide Ball with Blocks
			var collisionBlock:Block = null;
			var blocksLength:uint = _Blocks.length;
			var activeBlocks:uint = 0;
			for (i = 0; i < blocksLength; i++) {
				if (!_Blocks[i] || !_Blocks[i] is Block || !_Blocks[i].Active)
					continue;
					
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
				_Score += 100;
				_HUD.Score.text = String(_Score);
				
				ClonePowerupByType(collisionBlock.PowerupName, collisionBlock.Left, collisionBlock.Bottom);
			}
			
			// End Level if No More Blocks
			if (activeBlocks < 1)
				_LevelWon = true;		
			
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
				_Balls--;
				_FailSound.Play();	
				Reset();
				if (_Balls < 0)
					_GameOver = true;
			}
		}
		
		public function Render():void
		{
			var blocksLength:uint = _Blocks.length;
			for (var i:uint = 0; i < blocksLength; i++) {
				if (_Blocks[i] && _Blocks[i] is Block)
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