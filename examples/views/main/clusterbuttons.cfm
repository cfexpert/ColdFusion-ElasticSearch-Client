<cfscript>
	helper = getBeanFactory().getBean("helper");
	status = rc.data.getClusterInfo.status;
	buttonstyle = helper.getClusterHealthButtonColor( status );
</cfscript>
<cfoutput>
	<div class="row">
		<div class="col-sm-2"><span class="btn#buttonstyle#"> <span class="glyphicon glyphicon-exclamation-sign"> </span> #rc.data.getClusterInfo.cluster_name# </span></div>
	</div>
	<div class="row">
		&nbsp;
	</div>

	<div class="row">
		<div class="col-sm-12"><cfloop from="1" to="#arrayLen(rc.data.getNodeInfo.nodes)#" index="i">
			<span class="btn btn-info"> <cfif rc.data.getNodeInfo.nodes[i]["master_node"] eq "YES"> <span class="glyphicon glyphicon-flash"> </span> </cfif>  #rc.data.getNodeInfo.nodes[i]["name"]# </span> 
		</cfloop></div>
	</div>
</cfoutput>