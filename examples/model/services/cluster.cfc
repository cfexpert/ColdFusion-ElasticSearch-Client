component extends="examples.lib.baseservice" accessors="true" {

 	public function init(){
		return this;
	}

	public function getClusterInfo(){
		var retval = {};
		var getResponse = es.prepareRequest("_cluster/health","GET","").execute();
		retval = getResponse.getBody();
		return retval;
	}

}
