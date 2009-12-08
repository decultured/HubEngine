package HubMath
{
	import flash.geom.*;
	import nl.demonsters.debugger.MonsterDebugger;
	
	public class hCollision
	{
		public static function PointInAlignedRect(point:Point, rectLeft:Number, rectTop:Number, rectRight:Number, rectBottom:Number, margin:Number = 0):Boolean
		{
			if (rectLeft > rectRight) {
				var temp:Number = rectLeft;
				rectLeft = rectRight;
				rectRight = temp;
			}
			
			if (rectTop > rectBottom) {
				var temp2:Number = rectTop;
				rectTop = rectBottom;
				rectBottom = temp2;
			}
			
			
			if (point.x >= rectLeft - margin && point.x <= rectRight + margin && point.y >= rectTop - margin && point.y <= rectBottom + margin)
				return true;
			return false;			
		}

		public static function LineSegmentIntersectionPoint(line1point1:Point, line1point2:Point, line2point1:Point, line2point2:Point):Point
		{
			// Line One to Implicit Equation: ax + by = d
			var a1:Number = line1point1.y - line1point2.y;
			var b1:Number = line1point2.x - line1point1.x;
			var d1:Number = a1 * line1point1.x + b1 * line1point1.y;
			
			// Line Two to Implicit Equation: ax + by = d
			var a2:Number = line2point1.y - line2point2.y;
			var b2:Number = line2point2.x - line2point1.x;
			var d2:Number = a2 * line2point1.x + b2 * line2point1.y;

			var Denom:Number = (a1*b2 - a2*b1);
			
			if (Denom == 0)
				return null;
				
			// Applying Cramer's Rule to Find Intersection Point
			return new Point((b2*d1 - b1*d2)/Denom,(a1*d2 - a2*d1)/Denom);
		}

		public static function LineSegmentToLineSegment(line1point1:Point, line1point2:Point, line2point1:Point, line2point2:Point):Boolean
		{
			var intersectPoint:Point = LineSegmentIntersectionPoint(line1point1, line1point2, line2point1, line2point2)
			
			if (!intersectPoint)
				return false;
			
			if (PointInAlignedRect(intersectPoint, line1point1.x, line1point1.y, line1point2.x, line1point2.y, 0.2) && PointInAlignedRect(intersectPoint, line2point1.x, line2point1.y, line2point2.x, line2point2.y, 0.2)) {
				return true;
			}
			return false;
		}
	}
}