component accessors="true" {

    property beanFactory;
    property helper;
	
	public function init(){
		return this;
	}

	public function getClusterInfo(){
		var retval = {};
		var config = [ { host="192.168.192.145", port="9200", path="", secure=false, username="", password="" } ];
		var clusterManager = new esclient.ClusterManager( config );
		var es = new esclient.ElasticSearchClient( clusterManager );
		var getResponse = es.prepareRequest("_cluster/health","GET","").execute();
		retval = getResponse.getBody();
		return retval;
	}

}
