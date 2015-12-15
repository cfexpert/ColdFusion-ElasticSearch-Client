<cfset rc.title = "Elasticsearch Node Info" />
<cfscript>
	helper = getBeanFactory().getBean("helper");
</cfscript>
<cfoutput>
	<div class="page-header">
		<h1>Elasticsearch Node Info</h1>
	</div>
	#view( "main/clusterbuttons" )#
	<p>&nbsp;</p>
	<cfdump var="#rc.data.getStats#">
</cfoutput>