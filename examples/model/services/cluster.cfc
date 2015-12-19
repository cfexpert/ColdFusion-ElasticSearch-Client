component extends="examples.lib.baseservice" accessors="true" {

 	public function init(){
		return this;
	}

	public function getClusterInfo(){
		var clusterInfo = {};
		var getResponse = es.prepareRequest( "_cluster/health", "GET", "" ).execute();
		clusterInfo = getResponse.getBody();
		return clusterInfo;
	}

}
