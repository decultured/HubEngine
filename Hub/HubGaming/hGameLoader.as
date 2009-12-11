package HubGaming
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import HubGraphics.*;
	import HubAudio.*;
	import nl.demonsters.debugger.MonsterDebugger;
	
	public class hGameLoader extends Sprite
	{
		public static var COMPLETE:String = "complete";

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
				
			var myXMLURL:URLRequest = new URLRequest(_URL);
			var myLoader:URLLoader = new URLLoader(myXMLURL);

			myLoader.addEventListener("complete", DataLoadComplete);
		}
		
		private function DataLoadComplete(event:Event):Boolean
		{
			var XMLData:XML = new XML( event.target.data );
			
			LoadData(XMLData);

			dispatchEvent(new Event(hGameLoader.COMPLETE));

			return true;
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
			
			return hGlobalGraphics.ImageLibrary.AddImage(newImage["@name"], newImage["@url"]);
		}
		
		protected function AddSound(newSound:XML):hSound
		{
			if (newSound["@name"] == undefined)
				return null;
			
			return hGlobalAudio.SoundLibrary.AddSound(newSound["@name"], newSound["@url"]);
		}
		
		protected function AddMusic(newMusic:XML):hSound
		{
			if (newMusic["@name"] == undefined)
				return null;
			
			return hGlobalAudio.SoundLibrary.AddSound(newMusic["@name"], newMusic["@url"]);
		}
	}	
}