package bbGameObjects
{
	import HubGaming.*;
	import HubGraphics.*;
	import HubInput.*;
	
	public class Paddle extends hGameObject
	{
		public function Paddle(imageFilename:String)
		{
			super(imageFilename);
			
			ResetTranslation(20, 440);
//			ResetVelocity(165, 0);
			//ResetAcceleration(0, 1000);
		}
		
		public override function Update(elapsedTime:Number):void
		{
			super.Update(elapsedTime);

//			ResetTranslation(hGlobalInput.Mouse.X - Width * 0.5, 440);
			
			if (hGlobalInput.Keyboard.KeyPressed(hKeyboard.RIGHT))
				ResetVelocity(165, 0);
			else if (hGlobalInput.Keyboard.KeyPressed(hKeyboard.LEFT))
				ResetVelocity(-165, 0);

/*			
			if (Position.x < 0) {
				Position.x = 0;
				ResetVelocity(Math.abs(Velocity.x), Velocity.y);
			}

			if (Position.x > hGlobalGraphics.Canvas.Width - Width) {
				Position.x = hGlobalGraphics.Canvas.Width - Width;
				ResetVelocity(-Math.abs(Velocity.x), Velocity.y);
			}
*/
		}
	}
}