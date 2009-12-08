package HubAudio
{	
	import flash.events.*;
	import flash.display.*;

	public class hSoundLibrary extends Sprite
	{
		public static var COMPLETE:String = "complete";
		public static var PROGRESS:String = "progress";

		private var _Sounds:Object;
		private var _LoaderQueue:Array;
		
		public function hSoundLibrary() 
		{
			_Sounds = new Object();
		}
		
		//TODO : Handle Replace = true
		public function AddSoundFromFile(filename:String, replace:Boolean = false):hSound
		{
			if (_Sounds[filename])
				return _Sounds[filename];
				
			var newSound:hSound = new hSound(filename);
			_Sounds[filename] = newSound;
			return newSound;
		}
		
		//TODO : Add sound if doesn't exist?
		public function GetSoundByFileName(filename:String):hSound
		{
			return _Sounds[filename];
		}
		
		public function LoadAllUnloadedSounds():void
		{
			//TODO : Add new images on subsequent calls
			if (_LoaderQueue != null && _LoaderQueue.length > 0)
				return;
			
			_LoaderQueue = new Array();
			for (var filename:String in _Sounds) {
				var newSound:hSound = _Sounds[filename];
				if (newSound && newSound.IsLoaded == false) {
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
			newSound.LoadFromFilename();
		}
		
		private function HandleComplete(event:Event):void
		{
			LoadNextUnloadedSound();
		}
	}
}