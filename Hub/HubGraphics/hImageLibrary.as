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
		private var _LoaderQueue:Array;
		
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
			return newImage;
		}
		
		public function GetImageByFileName(filename:String):hImage
		{
			return _Images[filename];
		}
		
		// TODO : Handle errors when files do not load
		public function LoadAllUnloadedImages():void
		{
			//TODO : Add new images on subsequent calls
			if (_LoaderQueue != null && _LoaderQueue.length > 0)
				return;
			
			_LoaderQueue = new Array();
			for (var filename:String in _Images) {
				var newImage:hImage = _Images[filename];
				if (newImage && newImage.IsLoaded == false) {
					_LoaderQueue.push(newImage);
				}
			}
			
			if (_LoaderQueue.length > 0)
				LoadNextUnloadedImage();
			else
				dispatchEvent(new Event(hImageLibrary.COMPLETE));			
		}
		
		private function LoadNextUnloadedImage():void
		{
			if (_LoaderQueue == null || _LoaderQueue.length == 0) {
				dispatchEvent(new Event(hImageLibrary.COMPLETE));
				return;
			}

			var newImage:hImage = _LoaderQueue.pop();
			newImage.addEventListener(hImage.COMPLETE, HandleComplete);
			newImage.LoadFromFilename();
		}
		
		private function HandleComplete(event:Event):void
		{
			LoadNextUnloadedImage();
		}
	}
}