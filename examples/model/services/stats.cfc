component extends="lib.baseservice" accessors="true" {

	public function init(){
		return this;
	}

	public function getStats(){
		var stats = [];
		var getResponse = es.prepareRequest( "_stats", "GET", "" ).execute();
		var indices = getResponse.getBody().indices;
		stats = extractStats( indices );
		return stats;
	}

	private function extractStats( indices ){
		var stats = [];
		var key = "";
		var currentNode = {};
		if ( !structIsEmpty( arguments.indices ) ){
			for ( key in arguments.indices ){
				currentNode[ "index" ] = key;
				currentNode[ "numberOfDocuments" ] = arguments.indices[ key ][ "primaries" ][ "docs" ][ "count" ];
				currentNode[ "mb" ] = round( arguments.indices[ key ][ "primaries" ][ "store" ][ "size_in_bytes" ] / ( 1024 * 1024 ) * 100 ) / 100;
				arrayAppend( stats, duplicate( currentNode ) );
			}
		}
		return stats;
	}

}
