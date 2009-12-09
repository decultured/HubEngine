package HubGraphics
{
	import mx.controls.*;
	import flash.display.*;
	import flash.geom.*;
		
	public class hGlobalGraphics
	{
		static protected var _View:hView;
		static protected var _ImageLibrary:hImageLibrary;
		static protected var _BackgroundImage:hImage = null;
		static protected var _BackgroundPosition:Point = new Point(0,0);
		
		static public function Initialize(viewImage:Image):void
		{
			if (_View == null)
				_View = new hView(viewImage);
			else
				_View.Initialize();
		}

		static public function get View():hView
		{
			return _View;
		}
		
		static public function get ImageLibrary():hImageLibrary
		{
			if (_ImageLibrary == null)
				_ImageLibrary = new hImageLibrary();
				
			return _ImageLibrary;
		}
		
		public static function BeginFrame(clear:Boolean = true, clearColor:uint = 0xffffff):void 
		{
			_View.Begin(clear, clearColor);

			if (_BackgroundImage)
				_BackgroundImage.RenderSimple(_View.ViewBitmapData, _BackgroundPosition);
		}
		
		public static function EndFrame():void
		{
			_View.End();	
		}

		public static function set BackgroundImage(name:String):void {_BackgroundImage = _ImageLibrary.GetImageFromName(name);}
	}
}