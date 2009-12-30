package mGameObjects
{
	import HubGaming.*;
	import HubGraphics.*;
	import HubInput.*;
	import flash.geom.*
	
	public class MeteorGameObject extends hGameObject
	{
		
		public function MeteorGameObject()
		{
			super();
		}
		
		public override function Update(elapsedTime:Number):void
		{
			super.Update(elapsedTime);
			
			if (Position.x + Width < 0)
				ResetTranslation(hGlobalGraphics.View.Width + Position.x, Position.y);
			else if (Position.x > hGlobalGraphics.View.Width)
				ResetTranslation(Position.x - hGlobalGraphics.View.Width, Position.y);

			if (Position.y + Height < 0)
				ResetTranslation(Position.x, hGlobalGraphics.View.Height + Position.y);
			else if (Position.y > hGlobalGraphics.View.Height)
				ResetTranslation(Position.x, Position.y - hGlobalGraphics.View.Height);
		}

		public override function Render():void
		{
			var oldPosition:Point = new Point(_Position.x, _Position.y);
			
			if (Position.x < 0) {
				ResetTranslation(hGlobalGraphics.View.Width + Position.x, Position.y);
				super.Render();
				ResetTranslation(oldPosition.x, oldPosition.y);
			} else if (Position.x + Width > hGlobalGraphics.View.Width) {
				ResetTranslation(Position.x - hGlobalGraphics.View.Width, Position.y);
				super.Render();
				ResetTranslation(oldPosition.x, oldPosition.y);
			}
			
			if (Position.y < 0) {
				ResetTranslation(Position.x, hGlobalGraphics.View.Height + Position.y);
				super.Render();
				ResetTranslation(oldPosition.x, oldPosition.y);
			} else if (Position.y + Height > hGlobalGraphics.View.Height) {
				ResetTranslation(Position.x, Position.y - hGlobalGraphics.View.Height);
				super.Render();
				ResetTranslation(oldPosition.x, oldPosition.y);
			}

			super.Render();
		}
	}
}