package HubGaming
{
	import flash.geom.*;
	import HubGraphics.*;
	
	public class hGameObject
	{
		private var _Image:hImage;

		private var _Visible:Boolean = true;
		private var _Active:Boolean = true; 

		private var _Position:Point = new Point(0, 0);
		private var _CenterOffsetPosition:Point = new Point(0, 0);
		private var _Scale:Number = 1.0;
		private var _Rotation:Number = 0.0;
		private var _Velocity:Point = new Point(0,0);
		private var _Acceleration:Point = new Point(0,0);
		private var _Forward:Point = new Point(0,1);

		private var _TransformMatrix:Matrix = new Matrix();

		public function get Top():Number {return _Position.y;}
		public function get Left():Number {return _Position.x;}
		public function get Bottom():Number
		{
			if (_Image)
				return _Position.y + _Image.Height;
			return _Position.y;
		}
		public function get Right():Number
		{
			if (_Image)
				return _Position.x + _Image.Width;
			return _Position.x;
		}
		public function get Width():Number {return _Image.Width;}
		public function get Height():Number {return _Image.Width;}
		public function get Scaler():Number {return _Scale;}
		public function get Position():Point {return _Position;}
		public function get Center():Point {return _CenterOffsetPosition;}
		public function get Rotation():Number {return _Rotation;}
		public function get Velocity():Point {return _Velocity;}
		public function get Acceleration():Point {return _Acceleration;}
		public function get Visible():Boolean {return _Visible;}
		public function get Active():Boolean {return _Active;}

		public function set Visible(visible:Boolean):void {_Visible = visible;}
		public function set Active(active:Boolean):void {_Active = active;}

		public function hGameObject(imageFilename:String)
		{
			_Image = hGlobalGraphics.ImageLibrary.AddImageFromFile(imageFilename);
		}
		
		public function ResetScale(newScale:Number = 1.0):void { _Scale = newScale; }
		public function Scale(Amount:Number):void { _Scale += Amount; }
		public function ResetRotation(newAngle:Number = 0.0):void { _Rotation = newAngle; }
		public function Rotate(Angle:Number):void {	_Rotation += Angle;	}

		public function ResetTranslation(X:Number = 0.0, Y:Number = 0.0):void
		{
			_Position.x = X;
			_Position.y = Y;
			CalcCenterOffsetPosition();
		}

		public function Translate(X:Number, Y:Number):void
		{
			_Position.x += X;
			_Position.y += Y;
			CalcCenterOffsetPosition();
		}
		
		public function ResetVelocity(X:Number = 0.0, Y:Number = 0.0):void
		{
			_Velocity.x = X;
			_Velocity.y = Y;
		}
		
		public function AddVelocity(X:Number = 0.0, Y:Number = 0.0):void
		{
			_Velocity.x += X;
			_Velocity.y += Y;
		}
		
		public function ResetAcceleration(X:Number = 0.0, Y:Number = 0.0):void
		{
			_Acceleration.x = X;
			_Acceleration.y = Y;
		}
		
		public function AddAcceleration(X:Number = 0.0, Y:Number = 0.0):void
		{
			_Acceleration.x += X;
			_Acceleration.y += Y;
		}
		
		private function CalcCenterOffsetPosition():void
		{
			if (_Image != null)
			{
				_CenterOffsetPosition.x = _Position.x + (_Image.Width * 0.5);
				_CenterOffsetPosition.y = _Position.y + (_Image.Height * 0.5);
			}
		}

		public function Update(elapsedTime:Number):void
		{
			if (!_Active)
				return;
			
			if (_Acceleration.x || _Acceleration.y )
				AddVelocity(_Acceleration.x * elapsedTime, _Acceleration.y * elapsedTime);
			
			if (_Velocity.x || _Velocity.y )
				Translate(_Velocity.x * elapsedTime, _Velocity.y * elapsedTime);
		}
		
		public function Render():void
		{
			if (!_Image || !_Visible)
				return;

			if (_Scale == 1.0 && _Rotation == 0.0) {
				_Image.RenderSimple(hGlobalGraphics.Canvas.ViewBitmap, _Position);
			} else {
				_TransformMatrix.identity();
				if (_Scale != 1.0)
					_TransformMatrix.scale(_Scale, _Scale);
				if (_Rotation != 0.0)
					_TransformMatrix.rotate(_Rotation);
				_TransformMatrix.translate(_Position.x, _Position.y);
				_Image.RenderTransformed(hGlobalGraphics.Canvas.ViewBitmap, _TransformMatrix);			
			}
		}
	}
}