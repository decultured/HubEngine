package mGameObjects
{
	import HubGaming.*;
	import HubGraphics.*;
	import HubInput.*;
	
	public class Ship extends hGameObject
	{
		private var _MaxXVelocity:Number = 400;
		private var _YPosition:Number = 400;
		
		public function get DefaultYPosition():Number {return _YPosition;}
		
		public function Ship()
		{
			super();
			
			ResetTranslation(0, _YPosition);
		}
		
		public function Reset():void
		{
		
		}
		
		public override function Update(elapsedTime:Number):void
		{
			if (hGlobalInput.Keyboard.KeyPressed(hKeyCodes.RIGHT_ARROW) && !hGlobalInput.Keyboard.KeyPressed(hKeyCodes.LEFT_ARROW))
				AddVelocity(_MaxXVelocity * elapsedTime * 10, 0);
			else if (hGlobalInput.Keyboard.KeyPressed(hKeyCodes.LEFT_ARROW) && !hGlobalInput.Keyboard.KeyPressed(hKeyCodes.RIGHT_ARROW))
				AddVelocity(-_MaxXVelocity * elapsedTime * 10, 0);
			else
				ResetVelocity(0, 0);

			if (Velocity.x > _MaxXVelocity)
				ResetVelocity(_MaxXVelocity, 0);
			if (Velocity.x < -_MaxXVelocity)
				ResetVelocity(-_MaxXVelocity, 0);

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