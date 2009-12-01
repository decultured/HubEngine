package HubGraphics
{	
	import flash.events.*;
	import flash.display.*;
	import flash.net.URLRequest;

	public class hImageLibrary extends Sprite
	{
		public static var COMPLETE:String = "complete";
		public static var PROGRESS:String = "progress";

		private var _Images:Object;
		
		private var _UnloadedImages:Number = 0;
		
		public function hImageLibrary() 
		{
			_Images = new Object();
		}
		
		//TODO : Handle Replace = true
		public function AddImageFromFile(filename:String, replace:Boolean = false):hImage
		{
			if (_Images[filename])
				return _Images[filename];
				
			var newImage:hImage = new hImage(filename);
			_Images[filename] = newImage;
			_UnloadedImages++;
			return newImage;
		}
		
		public function GetImageByFileName(filename:String):hImage
		{
			return _Images[filename];
		}
		
		public function LoadAllUnloadedImages():void
		{
			if (_UnloadedImages >= 0)
				LoadNextUnloadedImage();
		}
		
		private function LoadNextUnloadedImage():void
		{
			for (var filename:String in _Images) {
				var newImage:hImage = _Images[filename];
				if (newImage && newImage.IsLoaded == false) {
					newImage.addEventListener(hImage.COMPLETE, HandleComplete);
					newImage.LoadFromFilename();
					return;
				}
			}
			
			dispatchEvent(new Event(hImageLibrary.COMPLETE));
		}
		
		private function HandleComplete(event:Event):void
		{
			LoadNextUnloadedImage();
		}
	}
}