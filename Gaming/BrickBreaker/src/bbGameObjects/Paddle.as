package bbGameObjects
{
	import HubGaming.*;
	import HubGraphics.*;
	import HubInput.*;
	
	public class Paddle extends hGameObject
	{
		private var _MaxXVelocity:Number = 320; 
		private var _YPosition:Number = 440;
		
		public function get DefaultYPosition():Number {return _YPosition;}
		
		public function Paddle(imageName:String, imageURL:String)
		{
			super(imageName, imageURL);
			
			ResetTranslation(0, _YPosition);
		}
		
		public override function Update(elapsedTime:Number):void
		{
			if (hGlobalInput.Keyboard.KeyPressed(hKeyCodes.RIGHT_ARROW) && !hGlobalInput.Keyboard.KeyPressed(hKeyCodes.LEFT_ARROW))
				ResetVelocity(_MaxXVelocity, 0);
			else if (hGlobalInput.Keyboard.KeyPressed(hKeyCodes.LEFT_ARROW) && !hGlobalInput.Keyboard.KeyPressed(hKeyCodes.RIGHT_ARROW))
				ResetVelocity(-_MaxXVelocity, 0);
			else
				ResetVelocity(0, 0);

			super.Update(elapsedTime);
			
			if (Position.x < 0) {
				Position.x = 0;
			}

			if (Position.x > hGlobalGraphics.View.Width - Width) {
				Position.x = hGlobalGraphics.View.Width - Width;
			}

		}
	}
}