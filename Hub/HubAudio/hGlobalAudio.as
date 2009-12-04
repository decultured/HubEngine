package HubAudio
{
	public class hGlobalAudio
	{
		static protected var _SoundLibrary:hSoundLibrary;
		
		static public function get SoundLibrary():hSoundLibrary
		{
			if (_SoundLibrary == null)
				_SoundLibrary = new hSoundLibrary();
				
			return _SoundLibrary;
		}
	}
}