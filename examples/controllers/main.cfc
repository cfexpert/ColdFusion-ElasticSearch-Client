component accessors="true" {

    property beanFactory;
    property nodeService;
    property clusterService;
	
	public any function init( fw ) {
		variables.fw = fw;
		return this;
	}
	
	public void function default( rc ) {
		var config = [ { host="localhost", port="9200", path="", secure=false, username="", password="" } ];
		var clusterManager = new esclient.ClusterManager( config );
		es = new esclient.ElasticSearchClient( clusterManager );
		param name="rc.index" default="";
		param name="rc.type" default="";
		rc.data.getResponse = { "status" : "empty Response" };
		rc.searchString = "arzt";
		rc.index = "kb";
		rc.type = "";
		rc.data.getResponse = sendQuery( rc.searchString, rc.index, rc.type  );
	}

	public void function clusterInfo( rc ){
		rc.data.getClusterInfo = clusterService.getClusterInfo();
		rc.data.getNodeInfo = nodeService.getNodeInfo();
	}

	public void function nodeInfo( rc ){
		rc.data.getClusterInfo = clusterService.getClusterInfo();
		rc.data.getNodeInfo = nodeService.getNodeInfo();
	}

	private function sendQuery( string searchString, string index, string type ){
		var searchTerm = arguments.searchString;
		var docindex = arguments.index;
		var doctype = arguments.type;
		var fieldsToSearch = "file.content,filename,_id";
		var fieldToSearch = "file.content";
		var qb = es.queryBuilder();
		var searchQuery =qb.MultiMatchQuery( fieldsToSearch, searchTerm );
		//var searchQuery =qb.MatchQuery( fieldToSearch, searchTerm );
		var highlightField = new esclient.search.modifiers.HighlightField( "file.content" );
		var highlightModifier = new esclient.search.modifiers.HighlightModifier( [ highLightField ] );
		var sourceModifier = new esclient.search.modifiers.SourceModifier( [ "filen*", "fileu*", "pa*" ] );
		var getResponse = es.prepareSearch( docindex )
							.setTypes( doctype )
							.setQuery( searchQuery )
							.setModifiers( [ highlightModifier, sourceModifier ] )
							.setFilters([])
							.setFrom( 0 )
							.setSize( 50 )
							.execute();
		return getResponse.getBody()["hits"];
	}
	
}
