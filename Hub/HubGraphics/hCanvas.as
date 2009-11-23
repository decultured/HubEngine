package HubGraphics
{
	public class hCanvas
	{
		private var _ViewBitmap:BitmapData;
		
		public function ResetCanvas(viewBitmap:BitmapData):void
		{
			_ViewBitmap = viewBitmap;
			_GameState.ViewBitmap = _ViewBitmap;
			_MenuState.ViewBitmap = _ViewBitmap;
		}
		
		public function ResetCanvas(viewBitmap:BitmapData):void
		{
			_ViewBitmap = viewBitmap;
			_GameState.ViewBitmap = _ViewBitmap;
			_MenuState.ViewBitmap = _ViewBitmap;
		}
		
		
	}
}