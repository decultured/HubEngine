package HubAudio
{
	public class hGlobalAudio
	{
		static protected var _SoundLibrary:hSoundLibrary;
		static protected var _Music:hSound;
		
		static public function get SoundLibrary():hSoundLibrary
		{
			if (_SoundLibrary == null)
				_SoundLibrary = new hSoundLibrary();
				
			return _SoundLibrary;
		}
		
		static public function set Music(musicName:String):void {_Music = SoundLibrary.GetSoundFromName(musicName);}
		static public function PlayMusic():void {_Music.PlayOnlyOne(true);}
		static public function PauseMusic():void {_Music.Pause();}
		static public function StopMusic():void {_Music.Stop();}
		
		static public function Update():void
		{
			
		} 
	}
}