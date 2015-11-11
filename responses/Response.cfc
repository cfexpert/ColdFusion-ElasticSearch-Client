component accessors="true" implements="IResponse"{

	property name="success" type="boolean" default="false";
	property name="message";
	property name="status";
	property name="statuscode";
	property name="body";
	property name="headers";

	public function init(){
		return this;
	}

	public void function handleResponse(){

		var _httpResponse = arguments[1];
		setStatus(_httpResponse.StatusCode);
		setBody(deserializeJSON(_httpResponse.FileContent));
		setHeaders(_httpResponse.responseHeader);
		setStatusCode( getHeaders().status_code );

		if(getStatusCode() <= 206 && getStatusCode() >= 200){
			setSuccess(true);
		}
	}

	
}