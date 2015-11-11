component {
	// application variables
	this.name = "elasticsearch_client_#hash( getCurrentTemplatePath() )#";
	this.mappings["/examples"] = getDirectoryFromPath( getCurrentTemplatePath() );
	this.mappings["/lib"] = expandPath( "../" );
	this.appDir = replace( getCurrentTemplatePath(), "\","/", "all" );
	if ( left( this.appDir, 1 ) eq "/" ){
		// Linux, no drive letter
		this.driveLetter = "";
	} else {
		this.driveLetter = listGetAt( this.appDir, 1, "/" );
	}
	this.appVersion = "0.2.0.b10041";
	//
	this.sessionManagement = true;
	this.sessionTimeout = createTimeSpan(0,0,30,0);
	this.applicationTimeout = createTimeSpan(0,1,0,0);
	this.setClientCookies = true;
	this.loginStorage = "session";
	this.scriptProtect = true;
	// methods
	public void function onApplicationStart() {
		setupApplication();
	}

	public void function onSessionStart() {
	}

	public void function onRequestStart() {
		if ( structKeyExists( url, "reload") and len( trim( url.reload ) ) ){
			setupApplication();
		}
	}

	public string function getEnvironment() {
		return "dev";
	}

	public void function setupApplication() {
		application.appVersion = this.appVersion;
		application.appDir = replace( getCurrentTemplatePath(), "\","/", "all" );
		if ( left( application.appDir, 1 ) eq "/"){
			// Linux, no drive letter
			application.driveLetter = "";
		} else {
			application.driveLetter = listGetAt( application.appDir, 1, "/");
		}
		//
		application.debugipaddress = "0:0:0:0:0:0:0:1,127.0.0.1";
		application.adminEmail = "basket1@atginfotech.com";
	}

	
}
