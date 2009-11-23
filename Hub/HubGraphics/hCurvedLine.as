package HubGraphics 
{
	import flash.display.*;
	import flash.geom.Point;
	import HubMath.*;
	
	public class hCurvedLine 
	{
		private var Points:Vector.<hVector2D> = new Vector.<hVector2D>();
		private var ControlPoints:Vector.<hVector2D> = new Vector.<hVector2D>();
		private var MidPoints:Vector.<hVector2D> = new Vector.<hVector2D>();
		
		public function hCurvedLine() 
		{
			
		}
		
		public function ClearPoints():void
		{
			Points = new Vector.<hVector2D>();
			ControlPoints = new Vector.<hVector2D>();
			MidPoints = new Vector.<hVector2D>();
		}
		
		public function AddPoint(newPoint:Point, controlPointDistance:Number = 1):void
		{
			Points.push(new hVector2D(newPoint.x, newPoint.y));
			
			FindLastControlPoints(controlPointDistance);
			FindLastMidpoint();
		}
		
		public function NumPoints():Number
		{
			return Points.length;			
		}
		
		private function FindLastControlPoints(scale:Number = 1):Boolean
		{
			if (Points.length < 3 || ControlPoints.length >= (Points.length - 2) * 2 - 1)
				return false;
			
			var Point1:hVector2D = new hVector2D(Points[Points.length - 3].X, Points[Points.length - 3].Y);
			var Point2:hVector2D = new hVector2D(Points[Points.length - 2].X, Points[Points.length - 2].Y);
			var Point3:hVector2D = new hVector2D(Points[Points.length - 1].X, Points[Points.length - 1].Y);
			
			var Vector1:hVector2D = new hVector2D(Point2.X, Point2.Y);
			var Vector2:hVector2D = new hVector2D(Point3.X, Point3.Y);
			
			Vector1.Subtract(Point1);
			Vector2.Subtract(Point2);
			
			Vector1.Normalize();
			Vector2.Normalize();
			
			Vector1.Add(Vector2);
			Vector1.Normalize();
			Vector1.Scale(scale);
			
			var ControlPoint1:hVector2D = new hVector2D(Vector1.X, Vector1.Y);
			ControlPoint1.Invert();
			ControlPoint1.Add(Point2);
			var ControlPoint2:hVector2D = new hVector2D(Vector1.X, Vector1.Y);
			ControlPoint2.Add(Point2);

			ControlPoints.push(ControlPoint1);
			ControlPoints.push(ControlPoint2);
			
			return true;
		}
		
		private function FindLastMidpoint():Boolean
		{
			if (Points.length < 4 || ControlPoints.length < 4 || MidPoints.length >= Points.length - 3)
				return false;
			
			var FirstControlPoint:hVector2D = ControlPoints[ControlPoints.length - 3];
			var SecondControlPoint:hVector2D = ControlPoints[ControlPoints.length - 2];
				
			var NewMidpoint:hVector2D = new hVector2D((FirstControlPoint.X + SecondControlPoint.X) / 2, (FirstControlPoint.Y + SecondControlPoint.Y) / 2);
			
			MidPoints.push(NewMidpoint);
			
			return true;
		}
		
		public function DrawPoints(shape:Shape, radius:Number = 3, position:Point = null, scale:Point = null):Boolean
		{
			var i:int = 3;
			
			if (!position)
				position = new Point();
			
			if (!scale)
				scale = new Point(1, 1);

			shape.graphics.lineStyle(1, 0xFF0000, 1 );
			for (i = 0; i < Points.length; i++)
			{
				shape.graphics.drawCircle(Points[i].X * scale.x + position.x, Points[i].Y * scale.y + position.y, radius);
			}
			
			shape.graphics.lineStyle(1, 0x00FF00, 1 );
			for (i = 0; i < ControlPoints.length; i++)
			{
				shape.graphics.drawCircle(ControlPoints[i].X * scale.x + position.x, ControlPoints[i].Y * scale.y + position.y, radius);
			}
			
			shape.graphics.lineStyle(1, 0x0000FF, 1 );
			for (i = 0; i < MidPoints.length; i++)
			{
				shape.graphics.drawCircle(MidPoints[i].X * scale.x + position.x, MidPoints[i].Y * scale.y + position.y, radius);
			}
			
			return true;
		}
		
		public function Draw(curvedLine:Shape, position:Point = null, scale:Point = null):Boolean
		{
			if (Points.length < 2)
				return false;

			if (!position)
				position = new Point();
			
			if (!scale)
				scale = new Point(1, 1);

			var i:int = 3;

			curvedLine.graphics.moveTo(Points[0].X * scale.x + position.x, Points[0].Y * scale.y + position.y);
			
			if (Points.length < 3)
			{
				curvedLine.graphics.lineTo(Points[1].X * scale.x + position.x, Points[0].Y * scale.y + position.y);
				return true;
			}
			
			curvedLine.graphics.curveTo(ControlPoints[0].X * scale.x + position.x, ControlPoints[0].Y * scale.y + position.y, Points[1].X * scale.x + position.x, Points[1].Y * scale.y + position.y);
			
			var cCP:int = 1;
			var cMP:int = 0;
			
			for (i = 2;  i < Points.length - 1; i++)
			{
				curvedLine.graphics.curveTo(ControlPoints[cCP].X * scale.x + position.x, ControlPoints[cCP].Y * scale.y + position.y, MidPoints[cMP].X * scale.x + position.x, MidPoints[cMP].Y * scale.y + position.y);
				
				cMP++;
				cCP++;
				
				curvedLine.graphics.curveTo(ControlPoints[cCP].X * scale.x + position.x, ControlPoints[cCP].Y * scale.y + position.y, Points[i].X * scale.x + position.x, Points[i].Y * scale.y + position.y);
				
				cCP++;
			}
			
			curvedLine.graphics.curveTo(ControlPoints[ControlPoints.length - 1].X * scale.x + position.x, ControlPoints[ControlPoints.length - 1].Y * scale.y + position.y, Points[Points.length -1].X * scale.x + position.x, Points[Points.length -1].Y * scale.y + position.y);

			return true;
		}
	}
	
}