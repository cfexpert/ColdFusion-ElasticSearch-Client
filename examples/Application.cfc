component extends="framework.one" {
	// application variables
	this.name = "elasticsearch_client_#hash( getCurrentTemplatePath() )#";
	this.mappings[ "/examples" ] = getDirectoryFromPath( getCurrentTemplatePath() );
	this.mappings["/framework"] = getDirectoryFromPath( getCurrentTemplatePath() ) & "framework";
	this.mappings["/lib"] = getDirectoryFromPath( getCurrentTemplatePath() ) & "lib";
	this.mappings[ "/esclient" ] = expandPath( "../" );
	this.appDir = replace( getCurrentTemplatePath(), "\","/", "all" );
	if ( left( this.appDir, 1 ) eq "/" ){
		// Linux, no drive letter
		this.driveLetter = "";
	} else {
		this.driveLetter = listGetAt( this.appDir, 1, "/" );
	}
	this.appVersion = "0.3.1.b10082";
	//
	this.sessionManagement = true;
	this.sessionTimeout = createTimeSpan( 0,0,30,0 );
	this.applicationTimeout = createTimeSpan( 0,1,0,0 );
	this.setClientCookies = true;
	this.loginStorage = "session";
	this.scriptProtect = true;
	
	variables.framework = {
		generateSES = true,
		diEngine = "di1",
		diLocations = "/examples/model,/examples/lib",
		environments = { dev = { reloadApplicationOnEveryRequest = true } },
		trace = false
	};
	

	public void function setupApplication() {
		var bf = getBeanFactory();
		var esConfig = [ { host="localhost", port="9200", path="", secure=false, username="", password="" } ];
		var clusterManager = new esclient.ClusterManager( esConfig );
		bf.injectProperties( "es", { "clusterManager" = clusterManager } );
	}


	function setupRequest() {
		// use setupRequest to do initialization per request
		request.context.startTime = getTickCount();
	}

	public string function getEnvironment() {
		return "dev";
	}
}
