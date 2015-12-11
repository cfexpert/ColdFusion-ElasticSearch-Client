<cfsetting enablecfoutputonly="false">
<!---<cfset request.layout = false>--->
<cfoutput>
	<div class="bootstrap-dialog type-danger size-normal in" tabindex="-1" style="display: block;" aria-hidden="false">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<div class="bootstrap-dialog-header">
						<div class="bootstrap-dialog-title"><b>ERROR!</b></div>
					</div>
				</div>
				<div class="modal-body">
					<div class="bootstrap-dialog-body">
						<div class="bootstrap-dialog-message">
							<p><b>Ein Fehler ist aufgetreten!</b></p>
							<table class="table">
								<tr>
									<cfset errortime = now()>
									<cfif structKeyExists( request, 'failedAction' )>
										<cfset erroraction = request.failedAction>
										<td><b>Action:</b></td> <td>#request.failedAction#</td>
									<cfelse>
										<cfset erroraction = "unknown">
										<td><b>Action:</b></td> <td>unknown</td>
									</cfif>
								</tr>
								<tr>
									<td><b>Error:</b></td> <td>#request.exception.cause.message#</td>
								</tr>
								<tr>
									<td><b>Type:</b></td> <td>#request.exception.cause.type#</td>
								</tr>
								<tr>
									<td><b>Details:</b></td> <td>#request.exception.cause.detail#</td>
								</tr>
							</table>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<div class="bootstrap-dialog-footer">
						<div class="bootstrap-dialog-footer-buttons">
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<cfset variables.errorsubject = "Fehler in Applikation RAK">
	<cfset variables.mailBody = { action=erroraction, aerrortime=errortime, aexecutable=cgi.script_name, exception=request.exception, sess=session } >
	<cfif findNoCase("localhost", CGI.HTTP_HOST) or getEnvironment() eq "dev">
		<cfdump var="#mailbody#" label="Error">
	<cfelse>	
		<cfmail from="info@atginfotech.com" to="info@atginfotech.com" subject="#variables.errorsubject#" server="mail.ultimop.at" port="366" type="html">
			<cfdump var="#mailbody#" label="Error">
		</cfmail>	
		<cfmail from="info@rgb.at" to="info@rgb.at" subject="#variables.errorsubject#" server="mail.rgb.at" type="html">
			<cfdump var="#mailbody#" label="Error">
		</cfmail>	
	</cfif>
</cfoutput>
