package bbGameObjects
{
	import HubGaming.*;
	import HubGraphics.*;
	import HubAudio.*;
	import nl.demonsters.debugger.MonsterDebugger;
	
	public class Ball extends hGameObject
	{
		private var _Speed:Number = 250;
		private var _MaxVelocity:Number = 320; 
		private var _WallBounceSound:hSound;
		
		public function get Speed():Number {return _Speed;}
		
		public function Ball(imageFilename:String)
		{
			super(imageFilename);
			_WallBounceSound = hGlobalAudio.SoundLibrary.AddSoundFromFile("button-16.mp3?n=12f34");
			
			Reset();
		}

		public function Reset():void
		{
			ResetTranslation(320, 400);
			ResetVelocity(205, -200);
			Velocity.normalize(_Speed);
		}
		
		public override function Update(elapsedTime:Number):void
		{
			super.Update(elapsedTime);
			
			if (Position.x < 0) {
				Position.x = Math.abs(Position.x);
				ResetVelocity(Math.abs(Velocity.x), Velocity.y);
				_WallBounceSound.Play();
			}

			if (Position.x > hGlobalGraphics.View.Width - Width) {
				Position.x = (hGlobalGraphics.View.Width - Width) * 2 - Position.x;
				ResetVelocity(-Math.abs(Velocity.x), Velocity.y);
				_WallBounceSound.Play();
			}

			if (Position.y < 0) {
				Position.y = Math.abs(Position.y);
				ResetVelocity(Velocity.x, Math.abs(Velocity.y));
				_WallBounceSound.Play();
			}

			/*if (Position.y > hGlobalGraphics.View.Height - Height) {
				Position.y = (hGlobalGraphics.View.Height - Height) * 2 - Position.y;
				ResetVelocity(Velocity.x, -Math.abs(Velocity.y));
				_WallBounceSound.Play();
			}*/

		}
	}
}