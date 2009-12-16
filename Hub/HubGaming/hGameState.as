package HubGaming 
{
	import flash.utils.*;
	
	public class hGameState
	{
		public static var CHANGE_STATE:String = "change state";
				
		protected var _ElapsedTime:Number = 0;
		
		public function hGameState() 
		{
		}
		
		public function get Name():String {return getQualifiedClassName(this);}
		
		public function Start():void
		{
		}
		
		public function Stop():void
		{
		}
		
		public function Run(elapsedTime:Number):String
		{
			_ElapsedTime = elapsedTime;
			
			return Name;
		}
	}
}