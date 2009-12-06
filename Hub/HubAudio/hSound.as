package HubAudio
{
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.events.*;
	import flash.media.*;
	import nl.demonsters.debugger.MonsterDebugger;
	
	public class hSound extends Sprite
	{
		public static var COMPLETE:String = "complete";

		private var _FileName:String;
		private var _Loaded:Boolean = false;
		
		private var _SoundChannel:SoundChannel;
		private var _Sound:Sound; 

		public function hSound(filename:String)
		{
			_FileName = filename;
		}

		public function get IsLoaded():Boolean { return _Loaded; }
		public function get FileName():String { return _FileName; }

		public function Play(loops:Number = 0):void
		{
			if (!_Loaded)
				return;
				
			_SoundChannel = _Sound.play(0,loops);
		}
		
		public function PlayOnlyOne(loops:Number = 0):void
		{
			if (!_Loaded || _SoundChannel)
				return;
				
			_SoundChannel = _Sound.play(0,loops);
		}
		
		public function Stop():void
		{
			if (_Loaded && _SoundChannel)
				_SoundChannel.stop();
		}

		public function set Volume(volume:Number):void
		{
			if (!_Loaded || !_SoundChannel)
				return;
				
			var transform:SoundTransform = _SoundChannel.soundTransform;
			transform.volume = volume;
			_SoundChannel.soundTransform = transform;
		}

		public function LoadFromFilename():void
		{
			_Sound = new Sound(new URLRequest(_FileName));
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
			dispatchEvent(new Event(hSound.COMPLETE));
		}
		
		private function HandleProgress(event:ProgressEvent):void
		{
			dispatchEvent(new Event(hSound.COMPLETE));
		}
		
		private function HandleComplete(event:Event):void
		{
			_Loaded = true;
			dispatchEvent(new Event(hSound.COMPLETE));
		}		
	}
}