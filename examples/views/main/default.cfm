<cfset rc.title = "Default View" />	<!--- set a variable to be used in a layout --->
<cfoutput>
	<div class="page-header">
		<h1>Elasticsearc Cluster Info</h1>
	</div>
	<cfdump var="#rc.data.getResponse#">
</cfoutput>