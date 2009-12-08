package HubGraphics
{
	import mx.controls.*;
	import flash.display.*;
	
	public class hGlobalGraphics
	{
		static protected var _View:hView;
		static protected var _ImageLibrary:hImageLibrary;
		
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
		
		
	}
}