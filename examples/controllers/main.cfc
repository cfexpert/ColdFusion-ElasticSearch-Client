component accessors="true" {

    property beanFactory;
    property nodeService;
    property clusterService;
    property statsService;
    property esQueryService;
	
	public any function init( fw ) {
		variables.fw = fw;
		return this;
	}
	
	public void function default( rc ) {
		param name="rc.index" default="";
		param name="rc.type" default="";
		param name="rc.searchString" default="";
		if ( len( trim( rc.searchString ) ) ){
			rc.data.getResponse = esQueryService.sendQuery( rc.searchString, rc.index, rc.type  );
		} else {
			rc.data.getResponse.hits = [];
		}
	}

	public void function clusterInfo( rc ){
		rc.data.getClusterInfo = clusterService.getClusterInfo();
		rc.data.getNodeInfo = nodeService.getNodeInfo();
		rc.data.getStats = statsService.getStats();
	}

	public void function nodeInfo( rc ){
		rc.data.getClusterInfo = clusterService.getClusterInfo();
		rc.data.getNodeInfo = nodeService.getNodeInfo();
		rc.data.getStats = statsService.getStats();
	}
	
}
