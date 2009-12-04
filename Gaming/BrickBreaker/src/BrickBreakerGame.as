package 
{
	import bbGameObjects.*;
	import HubGraphics.*;
	import HubAudio.*;
	
	public class BrickBreakerGame 
	{
		private var _Ball:Ball;
		private var _Paddle:Paddle;
		private var _Blocks:Array;
		private var _Cursor:Cursor;
		private var _ActiveBlocks:Number;

		private var _BrickBounceSound:hSound;
		private var _PaddleBounceSound:hSound;
		private var _FailSound:hSound;
		private var _Music:hSound;
		
      	public function BrickBreakerGame()
        {
			_Music = hGlobalAudio.SoundLibrary.AddSoundFromFile("fractal.mp3?n=1234");
			_BrickBounceSound = hGlobalAudio.SoundLibrary.AddSoundFromFile("button-29.mp3?n=1234");
			_PaddleBounceSound = hGlobalAudio.SoundLibrary.AddSoundFromFile("ballpaddle.mp3?n=34534");
			_FailSound = hGlobalAudio.SoundLibrary.AddSoundFromFile("button-10.mp3?n=1234");
			
			_Cursor = new Cursor("cursor.png?n=1234");
			_Ball = new Ball("ball.png?n=1234");
			_Paddle = new Paddle("paddle.png?n=1s34");
			_Blocks = new Array();
			for (var i:uint = 0; i < 15; i++)
			{
				for (var j:uint = 0; j < 10; j++)
				{
					var newBlock:Block = new Block("brick.png?n=1e34");
					newBlock.Translate(20 + i*40, 20 + j*15);
					_Blocks.push(newBlock);
				}				
			}
			_ActiveBlocks = _Blocks.length;
        }

		public function Update(elapsedTime:Number):void
		{
			_Music.PlayOnlyOne(999);
			_Ball.Update(elapsedTime);
			_Paddle.Update(elapsedTime);
			_Cursor.Update(elapsedTime);

			// Collide Ball with Blocks
			var blocksLength:uint = _Blocks.length;
			for (var i:uint = 0; i < blocksLength; i++) {
				if (!_Blocks[i] || !_Blocks[i] is Block || !_Blocks[i].Active)
					continue;
				
				if (_Ball.Center.x > _Blocks[i].Left && _Ball.Center.x < _Blocks[i].Right) {
					if (_Ball.Center.y > _Blocks[i].Top && _Ball.Center.y < _Blocks[i].Bottom) {
						_Blocks[i].Active = false;
						_Blocks[i].Visible = false;
						_BrickBounceSound.Play();
						_ActiveBlocks--;
						continue;
					}
				}
				_Blocks[i].Update(elapsedTime);
			}
			
			//Collide Ball With Paddle
			if (_Ball.Center.x > _Paddle.Left && _Ball.Center.x < _Paddle.Right && 
				_Ball.Center.y > _Paddle.Top && _Ball.Center.y < _Paddle.Bottom)
			{
				_Ball.Position.y = _Paddle.Top - _Ball.Height;
				_Ball.ResetVelocity(_Ball.Velocity.x, -Math.abs(_Ball.Velocity.y));
				_PaddleBounceSound.Play();
			}
			
			//Reset if Ball Hits Bottom
			if (_Ball.Bottom > hGlobalGraphics.Canvas.Height) {
				_Ball.Reset();
				ResetBlocks();
				_FailSound.Play();	
			}
						
			if (_ActiveBlocks < 1)
				ResetBlocks();			
		}
		
		public function ResetBlocks():void
		{
			var blocksLength:uint = _Blocks.length;
			for (var i:uint = 0; i < blocksLength; i++) {
				if (!_Blocks[i] || !_Blocks[i] is Block)
					continue;
				_Blocks[i].Active = true;
				_Blocks[i].Visible = true;
			}
			
			_ActiveBlocks = _Blocks.length;
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
			_Cursor.Render();
		}
	}
}