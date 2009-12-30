package HubGraphics
{	
	import flash.events.*;
	import flash.display.*;
	import flash.net.URLRequest;
	import nl.demonsters.debugger.MonsterDebugger;

	public class hImageLibrary extends EventDispatcher
	{
		public static var COMPLETE:String = "complete";
		public static var PROGRESS:String = "progress";
		public static var IO_ERROR:String = "io error";

		private var _Images:Object;
		private var _LoaderQueue:Array;
		
		public function hImageLibrary() 
		{
			_Images = new Object();
		}
		
		public function AddImage(name:String, url:String = null, replace:Boolean = false):hImage
		{
			if (name == null)
				return null;
			
			if (_Images[name])
			{
				if (url && (!_Images[name].URL || replace)) {
					_Images[name].URL = url;
					_Images[name].Loaded = false;
				}
				return _Images[name];
			}
				
			var newImage:hImage = new hImage(name, url);
			_Images[name] = newImage;
			return newImage;
		}
		
		public function GetImageFromName(name:String):hImage
		{
			if (_Images[name])
				return _Images[name];
			else return AddImage(name, null);
		}
		
		// TODO : Handle errors when files do not load
		public function LoadAllUnloadedImages():void
		{
			// TODO : Add new images on subsequent calls
			if (_LoaderQueue != null && _LoaderQueue.length > 0)
				return;
			
			_LoaderQueue = new Array();
			for (var name:String in _Images) {
				var newImage:hImage = _Images[name];
				if (newImage && newImage.Loaded == false) {
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
			MonsterDebugger.trace(this, newImage.URL);
			newImage.addEventListener(hImage.COMPLETE, HandleComplete);
			newImage.addEventListener(hImage.IO_ERROR, HandleError);
			newImage.LoadFromURL();
		}
		
		private function HandleComplete(event:Event):void
		{
			LoadNextUnloadedImage();
		}

		private function HandleError(event:Event):void
		{
			MonsterDebugger.trace(this, "Hello World!");
			dispatchEvent(new Event(hImageLibrary.IO_ERROR));	
		}
	}
}