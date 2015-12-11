component accessors="true" {

    property beanFactory;
    property helper;

	public function init(){
		return this;
	}

	public function getNodeInfo(){
		var retval = {};
		var config = [ { host="192.168.192.145", port="9200", path="", secure=false, username="", password="" } ];
		var clusterManager = new esclient.ClusterManager( config );
		var es = new esclient.ElasticSearchClient( clusterManager );
		var getResponse = es.prepareRequest("_nodes","GET","").execute();
		var nodes = getResponse.getBody().nodes;
		retval["cluster_name"] = getResponse.getBody().cluster_name;
		retval["nodes"] = extractNodes( nodes );
		return retval;
	}
	
	private function extractNodes( availableNodes ){
		var retval = [];
		var key = "";
		var currentNode = {};
		if ( !structIsEmpty( arguments.availableNodes ) ){
			for ( key in arguments.availableNodes ){
				currentNode[ "name" ] = arguments.availableNodes[key]["name"];
				currentNode[ "ip" ] = arguments.availableNodes[ key ][ "ip" ];
				currentNode[ "nodeid" ] = key;
				arrayAppend( retval, duplicate( currentNode ) );
			}
		}
		return retval;
	}

}
