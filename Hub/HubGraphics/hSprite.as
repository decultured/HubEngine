package HubGraphics
{
	import flash.geom.*;

	public class hSprite
	{
		protected var _Image:hImage;

		protected var _Visible:Boolean = true;
		protected var _Active:Boolean = true; 

		protected var _Width:Number = 0;
		protected var _Height:Number = 0;

		protected var _CurrentFrame:uint = 0;

		protected var _PreviousPosition:Point = new Point(0, 0);
		protected var _Position:Point = new Point(0, 0);
		protected var _PreviousCenter:Point = new Point(0, 0);
		protected var _Center:Point = new Point(0, 0);
		protected var _Scale:Number = 1.0;
		protected var _Rotation:Number = 0.0;
		protected var _RotationalVelocity:Number = 0.0;
		protected var _RotationalAcceleration:Number = 0.0;
		protected var _Velocity:Point = new Point(0,0);
		protected var _Acceleration:Point = new Point(0,0);
		protected var _Forward:Point = new Point(0,1);

		protected var _TransformMatrix:Matrix = new Matrix();
		
		public function get ImageName():String {if (_Image) return _Image.Name else return null;} 

		public function get Width():Number {return _Width;}
		public function get Height():Number {return _Height;}
		public function set Width(width:Number):void {_Width = width;}
		public function set Height(height:Number):void {_Height = height;}

		public function get Top():Number {return _Position.y;}
		public function get Left():Number {return _Position.x;}
		public function get Bottom():Number {return _Position.y + _Height;}
		public function get Right():Number {return _Position.x + _Width;}

		public function get Scaler():Number {return _Scale;}

		public function get Position():Point {return _Position;}
		public function get PreviousPosition():Point {return _PreviousPosition;}

		public function get Center():Point {return _Center;}
		public function get PreviousCenter():Point {return _PreviousCenter;}

		public function get Rotation():Number {return _Rotation;}
		public function get RotationalVelocity():Number {return _RotationalVelocity;}
		public function get RotationalAcceleration():Number {return _RotationalAcceleration;}
		public function get Velocity():Point {return _Velocity;}
		public function get Acceleration():Point {return _Acceleration;}

		public function get Visible():Boolean {return _Visible;}
		public function set Visible(visible:Boolean):void {_Visible = visible;}
		public function get Active():Boolean {return _Active;}
		public function set Active(active:Boolean):void {_Active = active;}

		public function get CurrentFrame():uint {return _CurrentFrame;}
		public function set CurrentFrame(currentFrame:uint):void {_CurrentFrame = currentFrame;}

		public function hSprite()
		{
		}

		public function GetImageName():String
		{
			return _Image.Name; 	
		}
		
		public function SetImage(imageName:String):hImage
		{
			_Image = hGlobalGraphics.ImageLibrary.GetImageFromName(imageName);
			
			return _Image;
		}
		
		public function ResetScale(newScale:Number = 1.0):void { _Scale = newScale; }
		public function Scale(Amount:Number):void { _Scale += Amount; }
		public function ResetRotation(newAngle:Number = 0.0):void { _Rotation = newAngle; }
		public function Rotate(Angle:Number):void {	_Rotation += Angle;	}
		public function ResetRotationalVelocity(newAngle:Number = 0.0):void { _RotationalVelocity = newAngle; }
		public function AddRotationalVelocity(Angle:Number):void {	_RotationalVelocity += Angle;	}
		public function ResetRotationalAcceleration(newAngle:Number = 0.0):void { _RotationalAcceleration = newAngle; }
		public function AddRotationalAcceleration(Angle:Number):void {	_RotationalAcceleration += Angle;	}

		public function ResetTranslation(X:Number = 0.0, Y:Number = 0.0):void
		{
			_Position.x = X;
			_Position.y = Y;
			CalcCenter();
		}

		public function Translate(X:Number, Y:Number):void
		{
			_Position.x += X;
			_Position.y += Y;
			CalcCenter();
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
		
		private function CalcCenter():void
		{
			if (_Image != null)
			{
				_Center.x = _Position.x + (_Image.Width * 0.5);
				_Center.y = _Position.y + (_Image.Height * 0.5);
			}
		}

		public function Update(elapsedTime:Number):void
		{
			if (!_Active)
				return;

			_PreviousPosition.x = _Position.x;
			_PreviousPosition.y = _Position.y;
			_PreviousCenter.x = _Center.x;
			_PreviousCenter.y = _Center.y;

			if (_Acceleration.x || _Acceleration.y )
				AddVelocity(_Acceleration.x * elapsedTime, _Acceleration.y * elapsedTime);
			
			if (_Velocity.x || _Velocity.y )
				Translate(_Velocity.x * elapsedTime, _Velocity.y * elapsedTime);
				
			if (_RotationalAcceleration)
				AddRotationalVelocity(_RotationalAcceleration * elapsedTime);
			
			if (_RotationalVelocity )
				Rotate(_RotationalVelocity * elapsedTime);
		}
		
		public function Render():void
		{
			if (!_Image || !_Visible)
				return;

			if (_Scale == 1.0 && _Rotation == 0.0) {
				_Image.RenderSimple(hGlobalGraphics.View.ViewBitmapData, _Position, _CurrentFrame);
			} else {
				_TransformMatrix.identity();
				if (_Scale != 1.0)
					_TransformMatrix.scale(_Scale, _Scale);
				if (_Rotation != 0.0)
					_TransformMatrix.rotate(_Rotation);
				_TransformMatrix.translate(_Position.x, _Position.y);
				_Image.RenderTransformed(hGlobalGraphics.View.ViewBitmapData, _TransformMatrix);			
			}
		}
	}
}