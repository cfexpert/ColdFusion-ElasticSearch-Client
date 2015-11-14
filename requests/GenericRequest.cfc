component accessors="true" {

	property name="Uri" type="string";
	property name="Method" type="string";
	property name="Body" type="string";
	

	property name="ClusterManager" type="ClusterManager";

	public function init(required ClusterManager){
		variables.ClusterManager = arguments.ClusterManager;
		return this;
	}

	public function execute(){
		return getClusterManager().doRequest(resource = getUri(),
												method=getMethod(),
												body=getBody(),
												responseType="Response");
	}

}