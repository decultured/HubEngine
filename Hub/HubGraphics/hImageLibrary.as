package HubGraphics
{	
	public class hImageLibrary
	{
		public var Images:Object;
		
		public function hImageLibrary() 
		{
			Images = new Object();
		}
		
		public function AddImage(name:String, filename:String, replace:Boolean = false):Boolean
		{
			newImage:hImage = new hImage(name)
		}
		
		public function GetImageByName(name:String):hImage
		{
			return Images["name"];
		}
		
		public function LoadAllImages():void
		{
			BitmapLoader = new Loader();

			BitmapLoader.contentLoaderInfo.addEventListener(Event.OPEN, HandleOpen);
			BitmapLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, HandleProgress);
			BitmapLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, HandleComplete);

			BitmapLoader.load(new URLRequest(_FileName));				
		}
		
		private function HandleOpen(event:Event):void
		{
		}
		
		private function HandleProgress(event:ProgressEvent):void
		{
		}
		
		private function HandleComplete(event:Event):void
		{
			LoadedImage = Bitmap(BitmapLoader.content);
			
			Size.y = LoadedImage.height;
			Size.x = LoadedImage.width;
			
			Bounds.width = LoadedImage.width;
			Bounds.height = LoadedImage.height;
			
			Loaded = true;
			
			dispatchEvent(new Event(hImage.COMPLETE))
		}		
	}
}