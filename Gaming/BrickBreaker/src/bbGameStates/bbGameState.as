package bbGameStates 
{
	import HubGaming.*;
	import flash.display.BitmapData;
	import flash.geom.*;
	import flash.utils.*;
	import HubGraphics.*;
	
	public class bbGameState extends hGameState
	{
		public var _BallImage:hImage;

		public function bbGameState() 
		{
			super();
		}
		
		public override function Start():void
		{
			_BallImage = hGlobalGraphics.ImageLibrary.GetImageByFileName("http://charting.local/static/images/brickbreaker/ball.png?n=1234");
		}
		
		public override function Stop():void
		{
		}
		
		public override function Run(elapsedTime:uint):String
		{
			_ElapsedTime = elapsedTime;

			var numBalls:uint = Math.round(Math.random()*5000);

			hGlobalGraphics.Canvas.Begin(true, 0x000000);
			
			for (var i:uint = 0; i < 100; i++)
			{
//				var position:Point = new Point(Math.round(Math.random()*640), Math.round(Math.random()*480))
				var matrix:Matrix = new Matrix();
				var scaleval:uint = Math.random()*5;
				matrix.scale(scaleval, scaleval);
				matrix.rotate(Math.random()*6.2918);
				matrix.translate(Math.round(Math.random()*640), Math.round(Math.random()*480));

				_BallImage.RenderTransformed(hGlobalGraphics.Canvas.ViewBitmap, matrix);
//				_BallImage.RenderSimple(hGlobalGraphics.Canvas.ViewBitmap, position);
			}

			hGlobalGraphics.Canvas.End();

			return Name;
		}
	}
}