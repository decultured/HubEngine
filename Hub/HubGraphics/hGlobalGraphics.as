package HubGraphics
{
	public class hGlobalGraphics
	{
		static protected var _Canvas:hCanvas;
		static protected var _ImageLibrary:hImageLibrary;
		
		static public function get Canvas():hCanvas
		{
			if (_Canvas == null)
				_Canvas = new hCanvas();
			
			return _Canvas;
		}
		
		static public function get ImageLibrary():hImageLibrary
		{
			if (_ImageLibrary == null)
				_ImageLibrary = new hImageLibrary();
				
			return _ImageLibrary;
		}
		
		
	}
}