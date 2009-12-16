package HubAudio
{
	import flash.net.URLRequest;
	import flash.events.*;
	import flash.media.*;
	
	public class hSound extends EventDispatcher
	{
		public static var COMPLETE:String = "complete";
		public static var PROGRESS:String = "progress";
		public static var IO_ERROR:String = "io error";

		private var _Name:String;
		private var _URL:String;
		private var _Loaded:Boolean = false;
		
		private var _PausedPosition:int = 0;
		private var _SoundChannel:SoundChannel;
		private var _Sound:Sound; 

		public function set Loaded(isLoaded:Boolean):void {_Loaded = isLoaded;}
		public function get Loaded():Boolean { return _Loaded; }
		public function get URL():String { return _URL; }
		public function set URL(url:String):void {_URL = url;}

		public function hSound(name:String, url:String = null)
		{
			_URL = url;
			_Name = name;
		}

		public function Play():void
		{
			if (!_Loaded)
				return;
				
			_SoundChannel = _Sound.play(0);
		}
		
		public function PlayOnlyOne(loops:Boolean = false):void
		{
			if (!_Loaded || _SoundChannel)
				return;
				
			_SoundChannel = _Sound.play(_PausedPosition);

			if (loops)
				_SoundChannel.addEventListener(Event.SOUND_COMPLETE, LoopSound);
		}
		

		public function LoopSound(event:Event):void
		{
			Stop();
			PlayOnlyOne(true);
		}
		
		public function Pause():void
		{
			if (!_Loaded || !_SoundChannel)
				return;

			_PausedPosition = _SoundChannel.position;
			_SoundChannel.stop();
			_SoundChannel = null;
		}
		
		public function Stop():void
		{
			if (!_Loaded || !_SoundChannel)
				return;

			_PausedPosition = 0;
			_SoundChannel.stop();
			_SoundChannel = null;
		}

		public function set Volume(volume:Number):void
		{
			if (!_Loaded || !_SoundChannel)
				return;
				
			var transform:SoundTransform = _SoundChannel.soundTransform;
			transform.volume = volume;
			_SoundChannel.soundTransform = transform;
		}

		public function LoadFromURL(url:String = null):void
		{
			if (!_URL) {
				if (url) {
					_URL = url;
				} else {
					dispatchEvent(new Event(hSound.IO_ERROR));
					return;
				}
			}
			
			_Sound = new Sound(new URLRequest(_URL));
			_Sound.addEventListener(IOErrorEvent.IO_ERROR, HandleError);
			_Sound.addEventListener(Event.OPEN, HandleOpen);
			_Sound.addEventListener(ProgressEvent.PROGRESS, HandleProgress);
			_Sound.addEventListener(Event.COMPLETE, HandleComplete);
		}

		private function HandleOpen(event:Event):void
		{
		}
		
		private function HandleError(event:IOErrorEvent):void
		{
			dispatchEvent(new Event(hSound.IO_ERROR));
		}
		
		private function HandleProgress(event:ProgressEvent):void
		{
			dispatchEvent(new Event(hSound.PROGRESS));
		}
		
		private function HandleComplete(event:Event):void
		{
			_Loaded = true;
			dispatchEvent(new Event(hSound.COMPLETE));
		}		
	}
}