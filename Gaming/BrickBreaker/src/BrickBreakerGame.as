package 
{
	import bbGameObjects.*;
	import HubGraphics.*;
	import HubAudio.*;
	import HubMath.*;
	import flash.geom.*;
	import bbGameUI.*;
	
	public class BrickBreakerGame 
	{
		public var _Ball:Ball;
		public var _Paddle:Paddle;
		public var _Blocks:Array;
		public var _Cursor:Cursor;
		public var _ActiveBlocks:Number;

		public var _BrickBounceSound:hSound;
		public var _PaddleBounceSound:hSound;
		public var _FailSound:hSound;
		public var _Music:hSound;
		public var _HUD:bbGameHUD;
		
		private var _NextLevel:String = "level1.xml";
		private var _Score:Number = 0;
		private var _Balls:Number = 1;
		private var _StartingBalls:Number = 3;
		private var _GameOver:Boolean = false;

		public function get Score():Number {return _Score;}
		public function get GameOver():Boolean {return _GameOver;}
		public function get NextLevel():String {return _NextLevel;}  
		public function set NextLevel(nextLevel:String):void {_NextLevel = nextLevel;}  
		
      	public function BrickBreakerGame()
        {
			_HUD = new bbGameHUD();

			_Music = hGlobalAudio.SoundLibrary.GetSoundFromName("background_music");
			_BrickBounceSound = hGlobalAudio.SoundLibrary.GetSoundFromName("ball_hits_brick");
			_PaddleBounceSound = hGlobalAudio.SoundLibrary.GetSoundFromName("ball_hits_paddle");
			_FailSound = hGlobalAudio.SoundLibrary.GetSoundFromName("ball_lost");
			
			_Cursor = new Cursor();
			_Ball = new Ball();
			_Paddle = new Paddle();
			_Blocks = new Array();

			Reset();
        }

		public function AddBlock(imageName:String, shape:String, xPos:Number, yPos:Number, width:Number, height:Number):void
		{
			var newBlock:Block = new Block();
			newBlock.Width = width;
			newBlock.Height = height;
			newBlock.SetImage(imageName);
			newBlock.Translate(xPos, yPos);
			_Blocks.push(newBlock);
		}
		
		public function AddPaddle(imageName:String, width:Number, height:Number):void
		{
			_Ball.SetImage(imageName);
			_Ball.Width = width;
			_Ball.Height = height;
		}
		
		public function AddBall(imageName:String, width:Number, height:Number):void
		{
			_Ball.SetImage(imageName);
			_Ball.Width = width;
			_Ball.Height = height;
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
		}

		public function Reset(clear:Boolean = false):void
		{
			if (clear)
			{
				var blocksLength:uint = _Blocks.length;
				for (var i:uint = 0; i < blocksLength; i++) {
					if (!_Blocks[i] || !_Blocks[i] is Block)
						continue;
					_Blocks[i].Active = true;
					_Blocks[i].Visible = true;
				}
				
				_GameOver = false;
				_Score = 0;
				_Balls = _StartingBalls;
				_HUD.Balls.text = String(_Balls);
				_HUD.Score.text = String(_Score);
			}
			
			_Ball.ResetTranslation(320 - _Ball.Width * 0.5, 400);
			_Ball.ResetVelocity(205, -200);
			_Paddle.ResetTranslation(320 - _Paddle.Width * 0.5, _Paddle.DefaultYPosition)
			_ActiveBlocks = _Blocks.length;
		}
		
		public function get HUD():bbGameHUD {return _HUD;}

		public function ShowHUD():void
		{
			hGlobalGraphics.View.ViewImage.addChild(_HUD);			
		}

		public function HideHUD():void
		{
			hGlobalGraphics.View.ViewImage.removeChild(_HUD);
		}

		public function Update(elapsedTime:Number):void
		{
//			_Music.PlayOnlyOne(999);
			_Ball.Update(elapsedTime);
			_Paddle.Update(elapsedTime);

			// Collide Ball with Blocks
			var blocksLength:uint = _Blocks.length;
			for (var i:uint = 0; i < blocksLength; i++) {
				if (!_Blocks[i] || !_Blocks[i] is Block || !_Blocks[i].Active)
					continue;
				_Blocks[i].Update(elapsedTime);
				
				if (hCollision.PointInAlignedRect(_Ball.Center, _Blocks[i].Left, _Blocks[i].Top, _Blocks[i].Right, _Blocks[i].Bottom, _Ball.Width * 15.5)) {
					var TopLeft:Point = new Point(_Blocks[i].Left, _Blocks[i].Top);
					var TopRight:Point = new Point(_Blocks[i].Right, _Blocks[i].Top);
					var BottomLeft:Point = new Point(_Blocks[i].Left, _Blocks[i].Bottom);
					var BottomRight:Point = new Point(_Blocks[i].Right, _Blocks[i].Bottom);

					var intersect:Point;
					var collided:Boolean = false;
					// Bottom Side
					if (_Ball.Velocity.y < 0) {
						intersect = hCollision.LineSegmentIntersectionPoint(_Ball.PreviousCenter, _Ball.Center, BottomLeft, BottomRight);
						if (intersect != null && intersect.x >= _Blocks[i].Left && intersect.x <= _Blocks[i].Right && _Ball.PreviousCenter.y > _Blocks[i].Bottom && _Ball.Center.y < _Blocks[i].Bottom) {
							_Ball.ResetTranslation(intersect.x - _Ball.Width * 0.5, intersect.y - _Ball.Height * 0.5);
//							_Ball.ResetTranslation(_Ball.Position.x, 2 * _Blocks[i].Bottom - _Ball.Position.y);
							_Ball.ResetVelocity(_Ball.Velocity.x, Math.abs(_Ball.Velocity.y));
							collided = true;
						}
					}
					// Top Side
					else if (_Ball.Velocity.y > 0) {
						intersect = hCollision.LineSegmentIntersectionPoint(_Ball.PreviousCenter, _Ball.Center, TopLeft, TopRight);
						if (intersect != null && intersect.x >= _Blocks[i].Left && intersect.x <= _Blocks[i].Right && _Ball.PreviousCenter.y < _Blocks[i].Top && _Ball.Center.y > _Blocks[i].Top) {
							_Ball.ResetTranslation(intersect.x - _Ball.Width * 0.5, intersect.y - _Ball.Height * 0.5);
//							_Ball.ResetTranslation(_Ball.Position.x, 2 * _Blocks[i].Top + _Ball.Position.y);
							_Ball.ResetVelocity(_Ball.Velocity.x, -Math.abs(_Ball.Velocity.y));
							collided = true;
						}
					}
					// Right Side
					if (_Ball.Velocity.x < 0) {
						intersect = hCollision.LineSegmentIntersectionPoint(_Ball.PreviousCenter, _Ball.Center, TopRight, BottomRight);
						if (intersect != null && intersect.y >= _Blocks[i].Top && intersect.y <= _Blocks[i].Bottom && _Ball.PreviousCenter.x > _Blocks[i].Right && _Ball.Center.x < _Blocks[i].Right) {
							_Ball.ResetTranslation(intersect.x - _Ball.Width * 0.5, intersect.y - _Ball.Height * 0.5);
							_Ball.ResetVelocity(Math.abs(_Ball.Velocity.x), _Ball.Velocity.y);
							collided = true;
						}
					}
					// Left Side
					else if (_Ball.Velocity.x > 0) {
						intersect = hCollision.LineSegmentIntersectionPoint(_Ball.PreviousCenter, _Ball.Center, TopLeft, BottomLeft);
						if (intersect != null && intersect.y >= _Blocks[i].Top && intersect.y <= _Blocks[i].Bottom && _Ball.PreviousCenter.x < _Blocks[i].Left && _Ball.Center.x > _Blocks[i].Left) {
							_Ball.ResetTranslation(intersect.x - _Ball.Width * 0.5, intersect.y - _Ball.Height * 0.5);
							_Ball.ResetVelocity(-Math.abs(_Ball.Velocity.x), _Ball.Velocity.y);
							collided = true;
						}
					}
					
					if (collided == true) {
						_Blocks[i].Active = false;
						_Blocks[i].Visible = false;
						_BrickBounceSound.Play();
						_ActiveBlocks--;
						_Score += 100;
						_HUD.Score.text = String(_Score);
						break;
					}
				}
			}
			
			//Collide Ball With Paddle
			if (hCollision.PointInAlignedRect(_Ball.Center, _Paddle.Left, _Paddle.Top, _Paddle.Right, _Paddle.Bottom))
			{
				_Ball.Position.y = _Paddle.Position.y - _Ball.Height;
				
				_Ball.AddVelocity((_Ball.Center.x - _Paddle.Center.x) * 8, 0);
				if (_Ball.Velocity.x > 250)
					_Ball.ResetVelocity(250, _Ball.Velocity.y);
				_Ball.Velocity.normalize(_Ball.Speed);
				_Ball.ResetVelocity(_Ball.Velocity.x, -Math.abs(_Ball.Velocity.y));
				_PaddleBounceSound.Play();
			}
			
			//Reset if Ball Hits Bottom
			if (_Ball.Bottom > hGlobalGraphics.View.Height) {
				_Ball.Reset();
				_Balls--;
				
				if (_Balls < 0)
					_GameOver = true;
				_HUD.Balls.text = String(_Balls);				
				Reset();
				_FailSound.Play();	
			}
						
			if (_ActiveBlocks < 1)
				Reset();			
		}
		
		public function Render():void
		{
			var blocksLength:uint = _Blocks.length;
			for (var i:uint = 0; i < blocksLength; i++) {
				if (_Blocks[i] && _Blocks[i] is Block)
					_Blocks[i].Render();
			}
			_Ball.Render();
			_Paddle.Render();
		}
	}
}