package HubGaming 
{
	import flash.utils.*;
	
	public class hGameState
	{
		protected var _ElapsedTime:uint = 0;
		
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
		
		public function Run(elapsedTime:uint):String
		{
			_ElapsedTime = elapsedTime;
			
			return Name;
		}
	}
}