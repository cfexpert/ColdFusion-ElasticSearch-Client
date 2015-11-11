component accessors="true" extends="Base" {

	
	property name="OutputUtils";
	property name="LoggingUtil";
	property name="ClusterManager";

	public ElasticSearchClient function init(required ClusterManager){
		variables.ClusterManager = arguments.ClusterManager;
		variables.OutputUtils = new OutputUtils();
	 	return this;
	}

	public FilterBuilder function filterBuilder(){
		return new search.filters.FilterBuilder();
	}

	public QueryBuilder function queryBuilder(){
		return new search.queries.QueryBuilder();
	}

	public FacetBuilder function facetBuilder(){
		return new search.facets.FacetBuilder();
	}

	public SearchRequest function prepareSearch(){
		var search = new requests.SearchRequest(argumentCollection=arguments);
			search.setClusterManager(getClusterManager());
		return search;
	}

	public IndexRequest function prepareIndex(string index="", string type="", string id=""){
		var retIndex = new requests.IndexRequest(ClusterManager=getClusterManager());
			retIndex.setIndex(arguments.index);
			retIndex.setType(arguments.type);
			retIndex.setId(arguments.id);
		return retIndex;
	}
	
	public MappingRequest function prepareMapping(required string index, required string type, required elasticsearch.indexing.TypeMapping typeMapping){
		var retIndex = new requests.MappingRequest(ClusterManager=getClusterManager());
			retIndex.setIndex(arguments.index);
			retIndex.setType(arguments.type);
			retIndex.setBody(typeMapping.getJson());
		return retIndex;
	}

	public BulkRequest function prepareBulk(boolean Transactional=false){
		return new requests.BulkRequest(Transactional=Arguments.Transactional, ClusterManager=getClusterManager(), OutputUtils=getOutputUtils(), ElasticSearchClient=this);
	}

	public MultiGetRequest function prepareMultiGet(){
		return new requests.MultiGetRequest(ClusterManager=getClusterManager(), OutputUtils=getOutputUtils());
	}

	public function prepareGet(string index="", string type="_all", string id=""){
		var get = new requests.GetRequest(ClusterManager=getClusterManager());
		get.setIndex(arguments.index);
		get.setType(arguments.type);
		get.setId(arguments.id);
		return get;
	}
	
	public DeleteRequest function prepareDelete(required string index, string type="", string id=""){
		var delete = new requests.DeleteRequest(ClusterManager=getClusterManager());
		delete.setIndex(arguments.index);
		delete.setType(arguments.type);
		delete.setId(arguments.id);
		return delete;
	}
	
	public GenericRequest function prepareRequest(required string uri, required string method, required string body){
		var genericRequest = new requests.GenericRequest(ClusterManager=getClusterManager());
		genericRequest.setUri(arguments.uri);
		genericRequest.setMethod(arguments.method);
		genericRequest.setBody(arguments.body);
		return genericRequest;
	}
	
}