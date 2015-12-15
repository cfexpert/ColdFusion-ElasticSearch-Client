component extends="examples.lib.baseservice" accessors="true" {

	public function init(){
		return this;
	}

	public function getStats(){
		var retval = [];
		var config = [ { host="localhost", port="9200", path="", secure=false, username="", password="" } ];
		var clusterManager = new esclient.ClusterManager( config );
		var es = new esclient.ElasticSearchClient( clusterManager );
		var getResponse = es.prepareRequest("_stats","GET","").execute();
		var indices = getResponse.getBody().indices;
		retval = extractStats( indices );
		return retval;
	}

	private function extractStats( indices ){
		var retval = [];
		var key = "";
		if ( !structIsEmpty( arguments.indices ) ){
			for ( key in arguments.indices ){
				currentNode[ "index" ] = key;
				currentNode[ "numberOfDocuments" ] = arguments.indices[ key ][ "primaries" ][ "docs" ][ "count" ];
				currentNode[ "mb" ] = round( arguments.indices[ key ][ "primaries" ][ "store" ][ "size_in_bytes" ] / ( 1024 * 1024 ) * 100 ) / 100;
				arrayAppend( retval, duplicate( currentNode ) ); 
			}
		}
		return retval;	}
	
}
