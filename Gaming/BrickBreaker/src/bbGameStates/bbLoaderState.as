package bbGameStates 
{
	import HubGaming.*;
	import flash.display.BitmapData;
	import flash.geom.*;
	import flash.utils.*;
	import HubGraphics.*;
	import HubAudio.*;
	import flash.events.*;
	import bbGameUI.*;
	
	public class bbLoaderState extends hGameState
	{
		private var _Complete:Boolean = false;
		private var _LoaderError:Boolean = false;
		public var _LoaderUI:bbLoader;

		public function bbLoaderState() 
		{
			super();
			_LoaderUI = new bbLoader();
		}

		private function CompleteEvent(event:MouseEvent):void { _Complete = true; }
		private function LoaderErrorClicked(event:MouseEvent):void { _LoaderError = true; }
		
		public override function Start():void
		{
			_Complete = false;
			_LoaderError = false;
			hGlobalGraphics.ImageLibrary.addEventListener(hImageLibrary.COMPLETE, HandleComplete);
			hGlobalGraphics.ImageLibrary.addEventListener(hImageLibrary.IO_ERROR, HandleLoaderError);
			hGlobalAudio.SoundLibrary.LoadAllUnloadedSounds();
			hGlobalGraphics.ImageLibrary.LoadAllUnloadedImages();

			hGlobalGraphics.View.ViewImage.addChild(_LoaderUI);
		}
		
		private function HandleLoaderError(event:Event):void
		{
			_LoaderUI.ErrorMessage.text = "Error Loading Required Files!"
			_LoaderUI.StartGameButton.addEventListener(MouseEvent.CLICK, LoaderErrorClicked);
			_LoaderUI.StartGameButton.enabled = true;
			_LoaderUI.StartGameButton.alpha = 100;
		}
		
		public override function Stop():void
		{
			hGlobalGraphics.View.ViewImage.removeChild(_LoaderUI);
			_LoaderUI.StartGameButton.removeEventListener(MouseEvent.CLICK, CompleteEvent);
		}
		
		public override function Run(elapsedTime:Number):String
		{
			if (_Complete)
				return getQualifiedClassName(bbGameState);
			if (_LoaderError)
				return getQualifiedClassName(bbMenuState);
			return Name;
		}
		
		private function HandleComplete(event:Event):void
		{
			_LoaderUI.StartGameButton.addEventListener(MouseEvent.CLICK, CompleteEvent);
			_LoaderUI.StartGameButton.enabled = true;
			_LoaderUI.StartGameButton.alpha = 100;
		}
	}
}
