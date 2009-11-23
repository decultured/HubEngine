package Visualization.DataManagement
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;

	public class gXMLLoader
	{
		public var XMLData:XML;
		
		public function gXMLLoader(fileName:String)
		{
			var XML_URL:String = fileName;
			var myXMLURL:URLRequest = new URLRequest(XML_URL);
			var myLoader:URLLoader = new URLLoader(myXMLURL);
			myLoader.addEventListener("complete", HandleComplete);
		}
		
		private function HandleOpen(event:Event):void
		{
			
		}
		
		private function HandleProgress(event:ProgressEvent):void
		{
			
		}
		
		private function HandleComplete(event:Event):void
		{
		  try {
			// Convert the downlaoded text into an XML instance
			XMLData = new XML( event.target.data );
			// At this point, example is ready to be used with E4X
			trace( XMLData );
			
		  } catch ( e:TypeError ) {
			// If we get here, that means the downloaded text could
			// not be converted into an XML instance, probably because 
			// it is not formatted correctly.
			trace( "Could not parse text into XML" );
			trace( e.message );
			}
		}
	}
}