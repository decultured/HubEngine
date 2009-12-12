package bbGameObjects
{
	import HubGaming.*;
	import HubGraphics.*;
	import HubMath.*;
	import flash.geom.*;
	
	public class Block extends hGameObject
	{
		private var _CollisionPoint:Point = new Point(0,0);
		private var _Collided:Boolean = false;

		// 0=top, 1=right, 2=bottom, 3=left
		private var _CollisionSide:uint = 0;
		
		public function get Collided():Boolean {return _Collided;}
		public function get CollisionPoint():Point {return _CollisionPoint;}
		public function get CollisionSide():uint {return _CollisionSide;}
		
		public function Block()
		{
			super();
		}
		
		public function DistanceSquaredToCollisionPoint(sourcePoint:Point):Number {
			return (sourcePoint.x - _CollisionPoint.x) * (sourcePoint.x - _CollisionPoint.x) + (sourcePoint.y - _CollisionPoint.y) * (sourcePoint.y - _CollisionPoint.y);
		}
		
		public function CollideWithLine(previousPosition:Point, position:Point):Point
		{
			_Collided = false;

			if (!hCollision.PointInAlignedRect(position, Left, Top, Right, Bottom, 20)) {
				_CollisionPoint.x = 0;
				_CollisionPoint.y = 0;
				return _CollisionPoint;
			}
			
			var TopLeft:Point = new Point(Left, Top);
			var TopRight:Point = new Point(Right, Top);
			var BottomLeft:Point = new Point(Left, Bottom);
			var BottomRight:Point = new Point(Right, Bottom);
			var collisionPoint:Point;
			// Bottom Side
			if (position.y - previousPosition.y < 0) {
				collisionPoint = hCollision.LineSegmentIntersectionPoint(previousPosition, position, BottomLeft, BottomRight);
				if (collisionPoint != null && collisionPoint.x >= Left && collisionPoint.x <= Right && previousPosition.y >= Bottom && position.y <= Bottom) {
					_CollisionPoint = collisionPoint;
					_CollisionSide = 2;
					_Collided = true;
				}
			}
			// Top Side
			else if (position.y - previousPosition.y > 0) {
				collisionPoint = hCollision.LineSegmentIntersectionPoint(previousPosition, position, TopLeft, TopRight);
				if (collisionPoint != null && collisionPoint.x >= Left && collisionPoint.x <= Right && previousPosition.y <= Top && position.y >= Top) {
					_CollisionPoint = collisionPoint;
					_CollisionSide = 0;
					_Collided = true;
				}
			}
			// Right Side
			if (position.x - previousPosition.x < 0) {
				collisionPoint = hCollision.LineSegmentIntersectionPoint(previousPosition, position, TopRight, BottomRight);
				if (collisionPoint != null && collisionPoint.y >= Top && collisionPoint.y <= Bottom && previousPosition.x >= Right && position.x <= Right) {
					_CollisionPoint = collisionPoint;
					_CollisionSide = 1;
					_Collided = true;
				}
			}
			// Left Side
			else if (position.x - previousPosition.x > 0) {
				collisionPoint = hCollision.LineSegmentIntersectionPoint(previousPosition, position, TopLeft, BottomLeft);
				if (collisionPoint != null && collisionPoint.y >= Top && collisionPoint.y <= Bottom && previousPosition.x <= Left && position.x >= Left) {
					_CollisionPoint = collisionPoint;
					_CollisionSide = 3;
					_Collided = true;
				}
			}
			
			if (!_Collided) {
				_CollisionPoint.x = 0;
				_CollisionPoint.y = 0;
			}
			
			return _CollisionPoint;
		}
	}
}