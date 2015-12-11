<cfset rc.title = "Elasticsearch Cluster Info" />
<cfoutput>
	<div class="page-header">
		<h1>Elasticsearch Cluster Info</h1>
	</div>
	#view( "main/clusterbuttons" )#
	<p>&nbsp;</p>
	<cfdump var="#rc.data.getClusterInfo#">
</cfoutput>