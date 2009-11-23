package HubMath
{
	import flash.geom.Point;

	public class hVector2D 
	{
		private var _X:Number;
		private var _Y:Number;
		
		public function hVector2D(NewX:Number = 0, NewY:Number = 0) 
		{
			_X = NewX;
			_Y = NewY;
		}
		
		public function get X():Number { return _X; }
		public function get Y():Number { return _Y; }
		public function set X(NewX:Number):void { _X = NewX; }
		public function set Y(NewY:Number):void { _Y = NewY; }
		
		public function SetZero():void { _X = 0.0; _Y = 0.0; }
		public function Set(NewX:Number=0, NewY:Number=0):void { _X=NewX; _Y=NewY; };
		public function SetFromVector(SourceVector:hVector2D):void { _X=SourceVector.X; _Y=SourceVector.Y; };
		public function SetFromPoint(sourcePoint:Point):void { _X=sourcePoint.x; _Y=sourcePoint.y; };

		public function Copy():hVector2D { return new hVector2D(_X, _Y); }
	
		public function Add(SourceVector:hVector2D):void { _X += SourceVector.X; _Y += SourceVector.Y; }
		public function Subtract(SourceVector:hVector2D):void { _X -= SourceVector.X; _Y -= SourceVector.Y;	}
		public function Scale(Value:Number):void { _X *= Value; _Y *= Value; }
		public function Invert():void { _X = -_X; _Y = -_Y; }
		
		public function Length():Number
		{
			return Math.sqrt((_X*_X)+(_Y*_Y));
		}
		
		public function LengthSquared():Number
		{
			return (_X*_X)+(_Y*_Y);
		}
		
		public function Abs():void
		{
			if (_X < 0) _X = -_X;
			if (_Y < 0) _Y = -_Y;
		}
		
		public function Normalize():Number
		{
			var length:Number = Math.sqrt(_X * _X + _Y * _Y);
			if (length < Number.MIN_VALUE)
			{
				return 0.0;
			}
			var invLength:Number = 1.0 / length;
			_X *= invLength;
			_Y *= invLength;
			
			return length;
		}
		
		public function MakeMidpoint(SecondVector:hVector2D):hVector2D
		{
			return new hVector2D((_X + SecondVector.X) / 2, (_Y + SecondVector.Y) / 2);
		}
	}
}