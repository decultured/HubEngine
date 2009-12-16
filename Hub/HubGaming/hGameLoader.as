package HubGaming
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import HubGraphics.*;
	import HubAudio.*;
	
	public class hGameLoader extends EventDispatcher
	{
		public static var COMPLETE:String = "complete";
		public static var PROGRESS:String = "progress";
		public static var IO_ERROR:String = "io error";

		private var _Filename:String = null;
		private var _URL:String = null;

		public function get URL():String {return _URL;}
		public function set URL(url:String):void {_URL = url;}
		
		public function hGameLoader() 
		{
		}
		
		public function Load():void
		{
			if (!_URL)
				return;
				
			var myLoader:URLLoader = new URLLoader();
			
			myLoader.addEventListener(Event.COMPLETE, HandleComplete);
			myLoader.addEventListener(IOErrorEvent.IO_ERROR, HandleError);
			myLoader.addEventListener(ProgressEvent.PROGRESS, HandleProgress);
			myLoader.addEventListener(Event.OPEN, HandleOpen);

			myLoader.load(new URLRequest(_URL));
		}
		
		private function HandleOpen(event:Event):void
		{

		}

		private function HandleError(event:IOErrorEvent):void
		{
			dispatchEvent(new Event(hGameLoader.IO_ERROR));
		}
		
		private function HandleProgress(event:ProgressEvent):void
		{
			dispatchEvent(new Event(hGameLoader.PROGRESS));
		}
		
		// TODO : Handle error when user does not have permissions.
		// Use the contentLoaderInfo property of Loader to check status,
		// Must be checked BEFORE content is checked at all.  Accessing
		// The content property of a loader object without permissions
		// causes an unreported error. 
		private function HandleComplete(event:Event):void
		{
			var XMLData:XML = new XML(event.target.data);
			
			LoadData(XMLData);

			dispatchEvent(new Event(hGameLoader.COMPLETE));
		}

		protected function LoadData(hubGame:XML):void
		{
			for each (var newSound:XML in hubGame..sound) {
				AddSound(newSound);
			}
			for each (var newMusic:XML in hubGame..music) {
				AddMusic(newMusic);
			}
			for each (var newImage:XML in hubGame..image) {
				AddImage(newImage);
			}
		}
		
		protected function AddImage(newImage:XML):hImage
		{
			if (newImage["@name"] == undefined)
				return null;
			
			var newImageClass:hImage = hGlobalGraphics.ImageLibrary.AddImage(newImage["@name"], newImage["@url"], true);
			
			if (!newImageClass)
				return null;
				
			if (newImage["@segment_width"] && newImage["@segment_height"])
				newImageClass.SetSegmentSize(uint(newImage["@segment_width"]), uint(newImage["@segment_height"]));
			
			if (newImage["@offset_x"])
				newImageClass.OffsetX = Number(newImage["@offset_x"]);
			if (newImage["@offset_y"])
				newImageClass.OffsetY = Number(newImage["@offset_y"]);
			
			return newImageClass;
		}
		
		protected function AddSound(newSound:XML):hSound
		{
			if (newSound["@name"] == undefined)
				return null;
			
			return hGlobalAudio.SoundLibrary.AddSound(newSound["@name"], newSound["@url"], true);
		}
		
		protected function AddMusic(newMusic:XML):hSound
		{
			if (newMusic["@name"] == undefined)
				return null;
			
			hGlobalAudio.Music = newMusic["@name"];
			
			return hGlobalAudio.SoundLibrary.AddSound(newMusic["@name"], newMusic["@url"], true);
		}
	}	
}