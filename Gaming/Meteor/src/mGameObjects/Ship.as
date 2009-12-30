package mGameObjects
{
	import HubGaming.*;
	import HubGraphics.*;
	import HubInput.*;
	
	public class Ship extends MeteorGameObject
	{
		private var _MoveAcceleration:Number = 150;
		private var _MaxVelocity:Number = 400;
		private var _MaxVelocitySquared:Number = 160000;
		private var _MaxRotationalVelocity:Number = 3.5;
		
		public function Ship()
		{
			super();
			Centered = true;
		}
		
		public function Reset():void
		{
		
		}
		
		public override function Update(elapsedTime:Number):void
		{
			if (hGlobalInput.Keyboard.KeyPressed(hKeyCodes.RIGHT_ARROW) && !hGlobalInput.Keyboard.KeyPressed(hKeyCodes.LEFT_ARROW))
				Rotate(_MaxRotationalVelocity * elapsedTime);
			else if (hGlobalInput.Keyboard.KeyPressed(hKeyCodes.LEFT_ARROW) && !hGlobalInput.Keyboard.KeyPressed(hKeyCodes.RIGHT_ARROW))
				Rotate(-_MaxRotationalVelocity * elapsedTime);
			if (hGlobalInput.Keyboard.KeyPressed(hKeyCodes.UP_ARROW) && !hGlobalInput.Keyboard.KeyPressed(hKeyCodes.DOWN_ARROW)) {
				AddVelocity(Math.sin(Rotation) * _MoveAcceleration * elapsedTime, -Math.cos(Rotation) * _MoveAcceleration * elapsedTime);
			} else if (hGlobalInput.Keyboard.KeyPressed(hKeyCodes.DOWN_ARROW) && !hGlobalInput.Keyboard.KeyPressed(hKeyCodes.UP_ARROW)) {
				AddVelocity(-Math.sin(Rotation) * _MoveAcceleration * elapsedTime, Math.cos(Rotation) * _MoveAcceleration * elapsedTime);
			}
			
			if (Velocity.x * Velocity.x + Velocity.y * Velocity.y > _MaxVelocitySquared)
				Velocity.normalize(_MaxVelocity);
			

			super.Update(elapsedTime);
		}
	}
}