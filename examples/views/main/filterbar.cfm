<cfscript>
	param name="rc.searchString" default=""; 
</cfscript>
<cfoutput>
	<div class="filterbar alert alert-info">
		<form id="dokumentfilterform" action="#buildURL(action = 'main.default')#" class="form-inline" role="form" method="post">
				&nbsp;<label for="searchstring"> Search: <input type="text" name="searchstring" id="searchstring" value="#rc.searchString#" /></label>
				&nbsp;<button id="btnSend" name="btnSend" class="btn btn-success"> Find </button>
		</form> 
	</div>
</cfoutput>
