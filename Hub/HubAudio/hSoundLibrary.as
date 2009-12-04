package HubAudio
{	
	import flash.events.*;
	import flash.display.*;

	public class hSoundLibrary extends Sprite
	{
		public static var COMPLETE:String = "complete";
		public static var PROGRESS:String = "progress";

		private var _Sounds:Object;
		
		private var _UnloadedSounds:Number = 0;
		
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
			_UnloadedSounds++;
			return newSound;
		}
		
		//TODO : Add sound if doesn't exist?
		public function GetSoundByFileName(filename:String):hSound
		{
			return _Sounds[filename];
		}
		
		public function LoadAllUnloadedSounds():void
		{
			if (_UnloadedSounds >= 0)
				LoadNextUnloadedSound();
		}
		
		private function LoadNextUnloadedSound():void
		{
			for (var filename:String in _Sounds) {
				var newSound:hSound = _Sounds[filename];
				if (newSound && newSound.IsLoaded == false) {
					newSound.addEventListener(hSound.COMPLETE, HandleComplete);
					newSound.LoadFromFilename();
					return;
				}
			}
			
			dispatchEvent(new Event(hSoundLibrary.COMPLETE));
		}
		
		private function HandleComplete(event:Event):void
		{
			LoadNextUnloadedSound();
		}
	}
}