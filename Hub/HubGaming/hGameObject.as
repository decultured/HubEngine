package HubGaming
{
	import flash.geom.*;
	import HubGraphics.*;
	
	public class hGameObject extends hAnimatedSprite
	{
		public function hGameObject()
		{
			super();
		}

		public function ObjectRectanglesCollide(object2:hGameObject):Boolean
		{
		    if (Bottom < object2.Top) return false;
		    if (Top > object2.Bottom) return false;
		    if (Right < object2.Left) return false;
		    if (Left > object2.Right) return false;

		    return true;
		}

		public function DistanceSquaredTo(sourcePoint:Point):Number {
			return (sourcePoint.x - Position.x) * (sourcePoint.x - Position.x) + (sourcePoint.y - Position.y) * (sourcePoint.y - Position.y);
		}
	}
}