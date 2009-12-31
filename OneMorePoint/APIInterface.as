package
{
	import flash.events.*;
	import flash.net.*;
	
	public class APIInterface {
		private static var _APIUri:String = 'http://onemorepoint.local/api/';
		
		private static var _AuthToken:String = null;
		
		public static function get APIUri():String {return _APIUri;}
		
		public static function get AuthToken():String {return _AuthToken;}
		public static function set AuthToken(authToken:String):void {_AuthToken = authToken;}
		
		public static function newRequest(http_method:String, func_name:String, req_params:Object):APIRequest {
			return new APIRequest(http_method, func_name, req_params);
		}
	}
}
