package
{
	import flash.events.*;
	import flash.net.*;
	
	public class APIRequest extends EventDispatcher {
		private var _http_method:String;
		private var _func_name:String;
		private var _parameters:URLVariables;
		
		private var _request:URLRequest;
		private var _loader:URLLoader;
		
		public static var COMPLETE:String = "complete";
		public static var IO_ERROR:String = "io error";
		
		public function APIRequest(http_method:String, func_name:String, req_params:Object) {
			_parameters = new URLVariables();
			_parameters.auth_token = APIInterface.AuthToken;
			
			for(var k:String in req_params) {
				_parameters[k] = req_params[k];
			}
			
			_request = new URLRequest();
			_request.url = APIInterface.APIUri + func_name +'?format=xml';
			
			_http_method = http_method
			if(_http_method.toUpperCase() == 'POST') {
				_request.method = URLRequestMethod.POST;
			} else {
				_request.method = URLRequestMethod.GET;
			}
			
			_request.data = _parameters;
			
			_loader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			_loader.addEventListener(APIRequest.COMPLETE, HandleComplete);
			_loader.addEventListener(APIRequest.IO_ERROR, HandleError);
		}
		
		public function sendRequest():void {
			try 
			{
				_loader.load(_request);
			} catch (error:Error) {
				dispatchEvent(new Event(APIRequest.IO_ERROR));
			}
		}
		
		private function HandleComplete(event:Event):void
		{
			var XMLData:XML = new XML(event.target.data);
			
			for each (var authToken:XML in XMLData..auth_token) {
				APIInterface.AuthToken = authToken.text();
			}
			
			dispatchEvent(new Event(APIRequest.COMPLETE));
		}

		private function HandleError(event:Event):void
		{
			dispatchEvent(new Event(APIRequest.IO_ERROR));
		}
	}
}