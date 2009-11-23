package HubGraphics
{
	public class hSprite
	{
		private var _Position:Point = new Point(0, 0);
		private var _Size:Point = new Point(0, 0);
		private var _Scale:Point = new Point(0, 0);
		private var _Bounds:Rectangle = new Rectangle(0, 0, 0, 0);
		
		private var _Image:hImage;
		
		public function hSprite()
		{
			
		}
		
		public function set Image(image:hImage):void {
			if (_Image != null)
				_Image = image;
		}
		
		public function set Position(point:Point):void {
			if (point != null)
				_Position = point;
		}
		
		public function get Position():Point {return _Position;}

		public function set Size(point:Point):void {
			if (point != null)
				_Size = point;
		}
		
		public function get Size():Point {return _Size;}

	}
}