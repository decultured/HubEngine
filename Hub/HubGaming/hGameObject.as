package HubGraphics
{
	public class hGameObject
	{
		private var _Image:hImage;

		// Private Variables
		private var _Position:Point = new Point(0, 0);
		private var _CenterOffsetPosition:Point = new Point(0, 0);
		private var _Scale:Number = 1.0;
		private var _Rotation:Number = 0.0;
		private var _TransformMatrix = new Matrix();
		
		public function get Scale():Number {return _Scale;}
		public function get Position():Point {return _Position;}
		public function get Rotation():Number {return _Rotation;}

		public function hGameObject(imageFilename:String)
		{
			
		}
		
		public function ResetScale(var newScale:Number = 1.0):void { _Scale = newScale; }
		public function Scale(var Amount:Number):void { _Scale += Amount; }
		public function ResetRotation(var newAngle:Number = 0.0):void { _Rotation = newAngle; }
		public function Rotate(var Angle:Number):void {	_Rotation += Angle;	}

		public function ResetTranslation(var X:Number = 0.0, var Y:Number = 0.0):void
		{
			_Position.x = X;
			_Position.y = Y;
			CalcCenterOffsetPosition();
		}

		public function Translate(var X:Number, var Y:Number):void
		{
			_Position.x += X;
			_Position.y += Y;
			CalcCenterOffsetPosition();
		}
		
		private function CalcCenterOffsetPosition():void
		{
			if (_Image != null)
			{
				_CenterOffsetPosition.x = _Position.x - (_Image.Size.x * 0.5);
				_CenterOffsetPosition.y = _Position.y - (_Image.Size.y * 0.5);
			}
		}

		public function Update(elapsedTime:uint):void
		{
			
		}
		
		public function Render():void
		{
			if (!_Image)
				return;

			if (_Scale == 1.0 && _Rotation == 0.0) {
				_BallImage.RenderSimple(hGlobalGraphics.Canvas.ViewBitmap, _Position);
			} else {
				_TransformMatrix.identity();
				if (_Scale != 1.0)
					matrix.scale(_Scale, _Scale);
				if (_Rotation != 0.0)
					matrix.rotate(_Rotation);
				matrix.translate(_Position.x, _Position.y);
				_BallImage.RenderTransformed(hGlobalGraphics.Canvas.ViewBitmap, matrix);			
			}
		}
	}
}