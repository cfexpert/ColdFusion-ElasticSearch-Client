<cfscript>
	rc.title = "Elasticsearch Query";
	result = rc.data.getResponse.hits;
</cfscript>
<cfoutput>
	<div class="page-header">
		<h1>Elasticsearch Query</h1>
	</div>
	#view( "main/filterbar" )#
	<div class="table-responsive">
		<table id="searchresult" class="table table-striped table-bordered table-hover">
			<thead>
				<tr>
					<th style="width: 5%;">Pos.</th>
					<th style="width: 5%;">Score</th>
					<th>Result</th>
					<th style="width: 10%;">&nbsp;</th>
				</tr>
			</thead>
			<tbody>
				<cfif arrayLen( result )>
					<cfloop from="1" to="#arrayLen( result )#" index="i">
						<cfset detailLink = buildURL(action = "main.detail", querystring = "")>
						<cfset downLoadLink = buildURL(action = 'main.download', queryString='')>
						<tr>
							<td>#i#</td>
							<td>#round( result[ i ][ "_score" ] * 100 )#%</td>
							<td>
								<b>#result[ i ][ "_source" ][ "filename" ]#</b><br>
								<cfif arrayLen( result[ i ][ "highlight" ][ "file.content" ] )>
									<cfloop from="1" to="#arrayLen( result[ i ][ "highlight" ][ "file.content" ] )#" index="j">
										 #result[ i ][ "highlight" ][ "file.content" ][ j ]#<br />
									</cfloop>
								</cfif>
							</td>
							<td>
								<a href="#downloadLink#" title="Dokument herunterladen" class="btn btn-xs btn-default" target="_blank"><span class="glyphicon glyphicon-download-alt"></span></a>&nbsp;
								<a href="#detailLink#" title="Dokument Details anzeigen" class="btn btn-xs btn-success"><span class="glyphicon glyphicon-search"></span></a>&nbsp;
							</td>
						</tr>
					</cfloop>
				<cfelse>
					<tr>
						<td colspan="6">
							<div class="alert alert-success">
								No documents found!
							</div>
						</td>
					</tr>
				</cfif>
			</tbody>
		</table>
	</div>

	<!--- <cfdump var="#rc.data.getResponse#"> --->
</cfoutput>