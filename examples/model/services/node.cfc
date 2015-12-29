component extends="lib.baseservice" accessors="true" {

 	public function init(){
		return this;
	}

	public function getNodeInfo(){
		var nodeInfo = {};
		var getResponse = es.prepareRequest( "_cluster/state", "GET", "" ).execute();
		var nodes = getResponse.getBody().nodes;
		nodeInfo[ "cluster_name" ] = getResponse.getBody().cluster_name;
		nodeInfo[ "master_node" ] = getResponse.getBody().master_node;
		nodeInfo[ "nodes" ] = extractNodes( nodes, nodeInfo[ "master_node" ] );
		return nodeInfo;
	}

	private function extractNodes( struct availableNodes, string masterNode ){
		var extractedNodeData = [];
		var key = "";
		var currentNode = {};
		if ( !structIsEmpty( arguments.availableNodes ) ){
			for ( key in arguments.availableNodes ){
				currentNode[ "name" ] = arguments.availableNodes[ key ][ "name" ];
				currentNode[ "nodeid" ] = key;
				if ( key eq arguments.masterNode ){
					currentNode[ "master_node" ] = "YES";
					arrayPrepend( extractedNodeData, duplicate( currentNode ) );
				} else {
					currentNode[ "master_node" ] = "NO";
					arrayAppend( extractedNodeData, duplicate( currentNode ) );
				}
			}
		}
		return extractedNodeData;
	}

}
