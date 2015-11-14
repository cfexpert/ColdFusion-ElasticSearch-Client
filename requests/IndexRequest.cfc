component accessors="true" {

	property name="Index" type="string";
	property name="Type" type="string";
	property name="Id" type="string";
	property name="Body" type="string";

	property name="ClusterManager";

	public function init(required ClusterManager){
		variables.ClusterManager = arguments.ClusterManager;
		return this;
	}

	public function execute(){
		return getClusterManager().doRequest(resource = "/#getIndex()#/#getType()#/#getId()#",
												method="PUT",
												body=getBody(),
												responseType="IndexResponse");
	}

}