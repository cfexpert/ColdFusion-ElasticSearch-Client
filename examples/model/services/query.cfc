component extends="examples.lib.baseservice" accessors="true" {

	public function init(){
		return this;
	}


	public function sendQuery( string searchString, string index, string type ){
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
