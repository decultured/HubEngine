package abGameObjects
{
	import HubGaming.*;
	import HubGraphics.*;
	import HubMath.*;
	import flash.geom.*;
	import HubAudio.*;
	
	public class Block extends hGameObject
	{
		static public var TOP_COLLISION:Number = 0;
		static public var RIGHT_COLLISION:Number = 1;
		static public var BOTTOM_COLLISION:Number = 2;
		static public var LEFT_COLLISION:Number = 3;
		
		private var _PowerupName:String = null;
		
		private var _CollisionPoint:Point = new Point(0,0);
		private var _Collided:Boolean = false;
		private var _CollisionSide:uint = TOP_COLLISION;
		
		public var _BrickBounceSound:hSound;

		public function get Collided():Boolean {return _Collided;}
		public function get CollisionPoint():Point {return _CollisionPoint;}
		public function get CollisionSide():uint {return _CollisionSide;}

		// TODO : Verify powerup types
		public function set PowerupName(powerupName:String):void {_PowerupName = powerupName;}
		public function get PowerupName():String {return _PowerupName;}
		
		public function Block()
		{
			super();
			_BrickBounceSound = hGlobalAudio.SoundLibrary.GetSoundFromName("ball_hits_brick");
			StartAnimation("block");
		}

		public function Hit():Powerup
		{
			Active = false;
			Visible = false;
			
			_BrickBounceSound.Play();

			return null;
		}
		
		public function DistanceSquaredToCollisionPoint(sourcePoint:Point):Number {
			return (sourcePoint.x - _CollisionPoint.x) * (sourcePoint.x - _CollisionPoint.x) + (sourcePoint.y - _CollisionPoint.y) * (sourcePoint.y - _CollisionPoint.y);
		}
		
		public function CollideWithLine(previousPosition:Point, position:Point):Point
		{
			_Collided = false;

			if (!hCollision.PointCollidesWithRect(position.x, position.y, Left, Top, Right, Bottom, 20)) {
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
					_CollisionSide = Block.BOTTOM_COLLISION;
					_Collided = true;
				}
			}
			// Top Side
			else if (position.y - previousPosition.y > 0) {
				collisionPoint = hCollision.LineSegmentIntersectionPoint(previousPosition, position, TopLeft, TopRight);
				if (collisionPoint != null && collisionPoint.x >= Left && collisionPoint.x <= Right && previousPosition.y <= Top && position.y >= Top) {
					_CollisionPoint = collisionPoint;
					_CollisionSide = Block.TOP_COLLISION;
					_Collided = true;
				}
			}
			// Right Side
			if (position.x - previousPosition.x < 0) {
				collisionPoint = hCollision.LineSegmentIntersectionPoint(previousPosition, position, TopRight, BottomRight);
				if (collisionPoint != null && collisionPoint.y >= Top && collisionPoint.y <= Bottom && previousPosition.x >= Right && position.x <= Right) {
					_CollisionPoint = collisionPoint;
					_CollisionSide = Block.RIGHT_COLLISION;
					_Collided = true;
				}
			}
			// Left Side
			else if (position.x - previousPosition.x > 0) {
				collisionPoint = hCollision.LineSegmentIntersectionPoint(previousPosition, position, TopLeft, BottomLeft);
				if (collisionPoint != null && collisionPoint.y >= Top && collisionPoint.y <= Bottom && previousPosition.x <= Left && position.x >= Left) {
					_CollisionPoint = collisionPoint;
					_CollisionSide = Block.LEFT_COLLISION;
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