package Visualization.Graphics 
{
	import flash.display.*;
	import flash.geom.Point;
	import GameAlchemist.Math.gVector2D;
	
	public class gCurvedLine 
	{
		private var Points:Vector.<gVector2D> = new Vector.<gVector2D>();
		private var ControlPoints:Vector.<gVector2D> = new Vector.<gVector2D>();
		private var MidPoints:Vector.<gVector2D> = new Vector.<gVector2D>();
		
		public function gCurvedLine() 
		{
			
		}
		
		public function AddPoint(newPoint:Point):void
		{
			Points.push(new gVector2D(newPoint.x, newPoint.y));
			
			FindLastControlPoints();
			FindLastMidpoint();
		}
		
		public function NumPoints():Number
		{
			return Points.length;			
		}
		
		private function FindLastControlPoints():Boolean
		{
			if (Points.length < 3 || ControlPoints.length >= (Points.length - 2) * 2 - 1)
				return false;
			
			var Point1:gVector2D = new gVector2D(Points[Points.length - 3].X, Points[Points.length - 3].Y);
			var Point2:gVector2D = new gVector2D(Points[Points.length - 2].X, Points[Points.length - 2].Y);
			var Point3:gVector2D = new gVector2D(Points[Points.length - 1].X, Points[Points.length - 1].Y);
			
			var Vector1:gVector2D = new gVector2D(Point2.X, Point2.Y);
			var Vector2:gVector2D = new gVector2D(Point3.X, Point3.Y);
			
			Vector1.Subtract(Point1);
			Vector2.Subtract(Point2);
			
			Vector1.Normalize();
			Vector2.Normalize();
			
			Vector1.Add(Vector2);
			Vector1.Normalize();
			Vector1.Scale(15);
			
			var ControlPoint1:gVector2D = new gVector2D(Vector1.X, Vector1.Y);
			ControlPoint1.Invert();
			ControlPoint1.Add(Point2);
			var ControlPoint2:gVector2D = new gVector2D(Vector1.X, Vector1.Y);
			ControlPoint2.Add(Point2);

			ControlPoints.push(ControlPoint1);
			ControlPoints.push(ControlPoint2);
			
			return true;
		}
		
		private function FindLastMidpoint():Boolean
		{
			if (Points.length < 4 || ControlPoints.length < 4 || MidPoints.length >= Points.length - 3)
				return false;
			
			var FirstControlPoint:gVector2D = ControlPoints[ControlPoints.length - 3];
			var SecondControlPoint:gVector2D = ControlPoints[ControlPoints.length - 2];
				
			var NewMidpoint:gVector2D = new gVector2D((FirstControlPoint.X + SecondControlPoint.X) / 2, (FirstControlPoint.Y + SecondControlPoint.Y) / 2);
			
			MidPoints.push(NewMidpoint);
			
			return true;
		}
		
		public function DrawPoints(shape:Shape):Boolean
		{
			var i:int = 3;

			shape.graphics.lineStyle(1, 0xFF0000, 1 );
			for (i = 0; i < Points.length; i++)
			{
				shape.graphics.drawCircle(Points[i].X, Points[i].Y, 3);
			}
			
			shape.graphics.lineStyle(1, 0x00FF00, 1 );
			for (i = 0; i < ControlPoints.length; i++)
			{
				shape.graphics.drawCircle(ControlPoints[i].X, ControlPoints[i].Y, 3);
			}
			
			shape.graphics.lineStyle(1, 0x0000FF, 1 );
			for (i = 0; i < MidPoints.length; i++)
			{
				shape.graphics.drawCircle(MidPoints[i].X, MidPoints[i].Y, 3);
			}
			
			return true;
		}
		
		public function Draw(curvedLine:Shape):Boolean
		{
			if (Points.length < 2)
				return false;

			var i:int = 3;

			curvedLine.graphics.lineStyle(1, 0x000000, 1 );
			curvedLine.graphics.moveTo(Points[0].X, Points[0].Y);
			
			if (Points.length < 3)
			{
				curvedLine.graphics.lineTo(Points[1].X, Points[0].Y);
				return true;
			}
			
			curvedLine.graphics.curveTo(ControlPoints[0].X, ControlPoints[0].Y, Points[1].X, Points[1].Y);
			
			var cCP:int = 1;
			var cMP:int = 0;
			
			for (i = 2;  i < Points.length - 1; i++)
			{
				curvedLine.graphics.curveTo(ControlPoints[cCP].X, ControlPoints[cCP].Y, MidPoints[cMP].X, MidPoints[cMP].Y);
				
				cMP++;
				cCP++;
				
				curvedLine.graphics.curveTo(ControlPoints[cCP].X, ControlPoints[cCP].Y, Points[i].X, Points[i].Y);
				
				cCP++;
			}
			
			curvedLine.graphics.curveTo(ControlPoints[ControlPoints.length - 1].X, ControlPoints[ControlPoints.length - 1].Y, Points[Points.length -1].X, Points[Points.length -1].Y);

			return true;
		}
	}
	
}