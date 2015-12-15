component extends="examples.lib.baseservice" accessors="true" {

 	public function init(){
		return this;
	}

	public function getNodeInfo(){
		var retval = {};
		var getResponse = es.prepareRequest("_cluster/state","GET","").execute();
		var nodes = getResponse.getBody().nodes;
		retval["cluster_name"] = getResponse.getBody().cluster_name;
		retval["master_node"] = getResponse.getBody().master_node;
		retval["nodes"] = extractNodes( nodes, retval[ "master_node" ] );
		return retval;
	}
	
	private function extractNodes( struct availableNodes, string masterNode ){
		var retval = [];
		var key = "";
		var currentNode = {};
		if ( !structIsEmpty( arguments.availableNodes ) ){
			for ( key in arguments.availableNodes ){
				currentNode[ "name" ] = arguments.availableNodes[key]["name"];
				currentNode[ "nodeid" ] = key;
				if ( key eq arguments.masterNode ){
					currentNode[ "master_node" ] = "YES";
					arrayPrepend( retval, duplicate( currentNode ) );
				} else {
					currentNode[ "master_node" ] = "NO";
					arrayAppend( retval, duplicate( currentNode ) );
				}
			}
		}
		return retval;
	}

}
