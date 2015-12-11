<cfscript>
	helper = getBeanFactory().getBean("helper");
	status = rc.data.getClusterInfo.status;
	buttonstyle = helper.getClusterHealthButtonColor( status );
</cfscript>
<cfoutput>
	<div>
		<span class="btn#buttonstyle#"> #rc.data.getClusterInfo.cluster_name# </span>
		<cfloop from="1" to="#arrayLen(rc.data.getNodeInfo.nodes)#" index="i">
			<span class="btn btn-info"> #rc.data.getNodeInfo.nodes[i]["name"]# </span>
		</cfloop>
	</div>
</cfoutput>