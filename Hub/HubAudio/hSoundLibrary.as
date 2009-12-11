package HubAudio
{	
	import flash.events.*;
	import flash.display.*;

	public class hSoundLibrary extends Sprite
	{
		public static var COMPLETE:String = "complete";
		public static var PROGRESS:String = "progress";
		public static var IO_ERROR:String = "io error";

		private var _Sounds:Object;
		private var _LoaderQueue:Array;
		
		public function hSoundLibrary() 
		{
			_Sounds = new Object();
		}
		
		public function AddSound(name:String, url:String = null, replace:Boolean = false):hSound
		{
			if (_Sounds[name])
			{
				if (url && (!_Sounds[name].URL || replace)) {
					_Sounds[name].URL = url;
					_Sounds[name].Loaded = false;
				}
				return _Sounds[name];
			}

			var newSound:hSound = new hSound(name, url);
			_Sounds[name] = newSound;
			return newSound;
		}

		public function GetSoundFromName(name:String):hSound
		{
			if (_Sounds[name])
				return _Sounds[name];
			else return AddSound(name, null);
		}
		
		public function LoadAllUnloadedSounds():void
		{
			// TODO : Add new images on subsequent calls
			if (_LoaderQueue != null && _LoaderQueue.length > 0)
				return;
			
			_LoaderQueue = new Array();
			for (var name:String in _Sounds) {
				var newSound:hSound = _Sounds[name];
				if (newSound && newSound.Loaded == false) {
					_LoaderQueue.push(newSound);
				}
			}
			
			if (_LoaderQueue.length > 0)
				LoadNextUnloadedSound();
			else
				dispatchEvent(new Event(hSoundLibrary.COMPLETE));	
		}
		
		private function LoadNextUnloadedSound():void
		{
			if (_LoaderQueue == null || _LoaderQueue.length == 0) {
				dispatchEvent(new Event(hSoundLibrary.COMPLETE));
				return;
			}

			var newSound:hSound = _LoaderQueue.pop();
			newSound.addEventListener(hSound.COMPLETE, HandleComplete);
			newSound.addEventListener(hSound.IO_ERROR, HandleError);
			newSound.LoadFromURL();
		}
		
		private function HandleComplete(event:Event):void
		{
			LoadNextUnloadedSound();
		}

		private function HandleError(event:Event):void
		{
			dispatchEvent(new Event(hSoundLibrary.IO_ERROR));	
		}
	}
}