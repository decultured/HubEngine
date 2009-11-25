package bbGameObjects
{
	import HubGaming.*;
	import HubGraphics.*;
	
	public class Ball extends hGameObject
	{
		public function Ball(imageFilename:String)
		{
			super(imageFilename);
			
			ResetTranslation(20, 20);
			ResetVelocity(105, 100);
			//ResetAcceleration(0, 1000);
		}
		
		public override function Update(elapsedTime:Number):void
		{
			super.Update(elapsedTime);
			
			if (Position.x < 0) {
				Position.x = Math.abs(Position.x);
				ResetVelocity(Math.abs(Velocity.x), Velocity.y);
			}

			if (Position.x > hGlobalGraphics.Canvas.Width) {
				Position.x = hGlobalGraphics.Canvas.Width * 2 - Position.x;
				ResetVelocity(-Math.abs(Velocity.x), Velocity.y);
			}

			if (Position.y < 0) {
				Position.y = Math.abs(Position.y);
				ResetVelocity(Velocity.x, Math.abs(Velocity.y));
			}

			if (Position.y > hGlobalGraphics.Canvas.Height) {
				Position.y = hGlobalGraphics.Canvas.Height * 2 - Position.y;
				ResetVelocity(Velocity.x, -Math.abs(Velocity.y));
			}
		}
	}
}