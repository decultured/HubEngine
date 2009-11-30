package 
{
	import bbGameObjects.*;
	
	public class BrickBreakerGame 
	{
		private var _Ball:Ball;
		private var _Paddle:Paddle;
		private var _Blocks:Array;
		private var _Cursor:Cursor;
		private var _ActiveBlocks:Number;
      	public function BrickBreakerGame()
        {
			_Cursor = new Cursor("http://charting.local/static/images/brickbreaker/cursor.png?n=1234");
			_Ball = new Ball("http://charting.local/static/images/brickbreaker/ball.png?n=1234");
			_Paddle = new Paddle("http://charting.local/static/images/brickbreaker/paddle.png?n=1234");
			_Blocks = new Array();
			for (var i:uint = 0; i < 14; i++)
			{
				for (var j:uint = 0; j < 10; j++)
				{
					var newBlock:Block = new Block("http://charting.local/static/images/brickbreaker/brick.png?n=1e34");
					newBlock.Translate(20 + i*40, 20 + j*15);
					_Blocks.push(newBlock);
				}				
			}
			_ActiveBlocks = _Blocks.length;
        }

		public function Update(elapsedTime:Number):void
		{
			_Ball.Update(elapsedTime);
			_Paddle.Update(elapsedTime);
			_Cursor.Update(elapsedTime);

			var blocksLength:uint = _Blocks.length;
			for (var i:uint = 0; i < blocksLength; i++) {
				if (!_Blocks[i] || !_Blocks[i] is Block || !_Blocks[i].Active)
					continue;
				
				if (_Ball.Center.x > _Blocks[i].Left && _Ball.Center.x < _Blocks[i].Right) {
					if (_Ball.Center.y > _Blocks[i].Top && _Ball.Center.y < _Blocks[i].Bottom) {
						_Blocks[i].Active = false;
						_Blocks[i].Visible = false;
						_ActiveBlocks--;
						continue;
					}
				}
				_Blocks[i].Update(elapsedTime);
			}
			
			if (_ActiveBlocks < 1) {
				for (i = 0; i < blocksLength; i++) {
					if (!_Blocks[i] || !_Blocks[i] is Block)
						continue;
					_Blocks[i].Active = true;
					_Blocks[i].Visible = true;
				}
				
				_ActiveBlocks = _Blocks.length;
			}
			
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