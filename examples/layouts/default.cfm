<cfsetting showdebugoutput="false" enablecfoutputonly="true">
<cfparam name="rc.message" default="#arrayNew(1)#">
<cfparam name="rc.info" default="#arrayNew(1)#">
<cfparam name="rc.pageTitle" default="CFML Elasticsearch Client">
<cfparam name="session.auth.isLoggedIn" default="false">
<cfoutput><!DOCTYPE html> 
<html>
	<head>
		<title><cfoutput>#rc.pageTitle#</cfoutput></title>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<meta name="robots" content="noindex">
		<meta name="author" content="">
		<meta name="description" content="">
		<!--- title set by a view - there is no default --->
		<link rel="stylesheet" type="text/css" href="#request.base#assets/css/bootstrap.css?201504080615" />
		<link rel="stylesheet" type="text/css" href="#request.base#assets/css/bootstrap-theme.css" />
		<link rel="stylesheet" type="text/css" href="#request.base#assets/css/bootstrap-dialog.min.css" />
		<link rel="stylesheet" type="text/css" href="#request.base#assets/css/customlayout.css?201504080615" />
		<link rel="stylesheet" type="text/css" href="#request.base#assets/css/print.css?201505130830" media="print" />
		<script type="text/javascript" src="#request.base#assets/js/jquery-1.10.2.min.js"></script>
		<script type="text/javascript" src="#request.base#assets/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="#request.base#assets/js/bootstrap-dialog.min.js"></script>
	</head>
	<body>
		<div id="wrap">
			<div class="navbar navbar-default" role="navigation">
				<div class="container">
					<div class="navbar-header">
						<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
							<span class="sr-only">Toggle navigation</span>
							<span class="icon-bar"></span>
							<span class="icon-bar"></span>
							<span class="icon-bar"></span>
						</button>
						<a class="navbar-brand" href="##">CFML Elasticsearch Client</a>
					</div>
					<div class="collapse navbar-collapse">
						<ul class="nav navbar-nav">
							<cfif session.auth.isLoggedIn>
								<cfset avatarstatus = "on">
							<cfelse>
								<cfset avatarstatus = "off">
							</cfif>
							<li<cfif getItem() eq "default"> class="active"</cfif>><a href="#buildUrl( 'main.default' )#">Home</a></li>
							<li<cfif getItem() eq "clusterinfo"> class="active"</cfif>><a href="#buildUrl( 'main.clusterinfo' )#">Cluster</a></li>
							<li<cfif getItem() eq "info"> class="active"</cfif>><a href="#buildUrl( 'main.nodeinfo' )#">Nodes</a></li>
						</ul>
						<!-- nabar right -->
						<ul class="nav navbar-nav navbar-right">
						<!-- dropdown -->
							<li class="dropdown text-nowrap">
								<a href class="dropdown-toggle clear" data-toggle="dropdown">
									<span class="thumb-sm avatar pull-right m-t-n-sm m-b-n-sm m-l-sm"><img src="#request.base#assets/images/photo.png" alt="..."><i class="#avatarstatus# md b-white bottom"></i></span><span class="hidden-sm hidden-md text-nowrap"> <cfif session.auth.isLoggedIn>(<b id="clock"></b>) </cfif></span> <b class="caret"></b>
								</a>
								<!-- dropdown -->
								<ul class="dropdown-menu animated fadeInRight w">
									<cfif session.auth.isLoggedIn>
										<li>
											<a href="#buildUrl( 'rakintern:login.logout' )#">Abmelden</a>
										</li>
									<cfelse>
										<li><a href="#buildUrl( 'rakintern:login' )#">Anmelden</a></li>
									</cfif>
								</ul>
								<!-- / dropdown -->
							</li>
						</ul>
						<!-- / navbar right -->
					</div><!--/.nav-collapse -->
				</div>
			</div>
			<div class="container">
				#body#
			</div>
		</div>
		<div id="footer">
			<div class="container">
				<div class="col-md-2">
					
				</div>
				<div class="col-md-8">
					CFML Elasticsearch Client &bull; #request.action# &bull; &copy; 2015 - #year(now())# &bull; Version: #this.appVersion# &bull; <a href="http://www.atginfotech.com" title="ATGInfotech" target="_blank">ATGInfotech</a><br />
					Powered by <a href="https://github.com/framework-one/fw1" title="FW/1" target="_blank">FW/1</a> version #variables.framework.version# * <a href="https://github.com/framework-one/di1" title="DI/1" target="_blank">DI/1</a> version #getDefaultBeanFactory().getVersion()#. This request took #getTickCount() - rc.startTime#ms.
				</div>
				<div class="col-md-2">
					<cfif left(Server.ColdFusion.ProductName,5) eq "Railo">
						<cfset poweredByLogo = "powered-by-railo.png">
					<cfelseif left(Server.ColdFusion.ProductName,5) eq "Lucee">
						<cfset poweredByLogo = "powered-by-lucee.png">
					<cfelse>
						<cfset poweredByLogo = "powered-by-coldfusion.png">
					</cfif>
					<img src="#request.base#assets/images/#poweredByLogo#" alt="Powered by #Server.ColdFusion.ProductName#" class="poweredbylogo thumb-xxs" width="40px" />
				</div>
			</div>
		</div>
		<cfif session.auth.isLoggedIn>
			<cfset appSessionTimeout = application.configBean.getProperty("sessionTimeout")>
			<script type="text/javascript">
				var start = resetStartDate();
				var sessionTimeout=#appSessionTimeout#;
				var advanceWarningRemainingTime = 300; // 5 mins Vorwarnung 
				var advanceWarningFlag = 0;
				function resetStartDate(){
					var startDate=new Date();
					return Date.parse(startDate)/1000;
				}
				function CountDown(){
					var now=new Date();
					now=Date.parse(now)/1000;
					var x=parseInt(sessionTimeout-(now-start),10);
					var hours = Math.floor(x/3600); 
					var minutes = Math.floor((x-(hours*3600))/60); 
					var seconds = x-((hours*3600)+(minutes*60));
					minutes=(minutes <= 9)?'0' + minutes:minutes;
					seconds=(seconds <= 9)?'0' + seconds:seconds;
					
					if(document.getElementById('clock').innerHTML != undefined ){
						document.getElementById('clock').innerHTML = hours  + ':' + minutes + ':' + seconds ;
					}
					
					if(x>0){
						timerID=setTimeout("CountDown()", 100)
						if( ( x < advanceWarningRemainingTime ) && ( advanceWarningFlag < 1 ) ){
							advanceWarningFlag++;
							var warningTimeout = Math.ceil( x / 60 * 100 ) / 100;
							var warningMessage = "Die automatische Abmeldung erfolgt in weniger als " + warningTimeout + " Minuten.";
							var buttonLabel = "<b>Nicht abmelden! Anmeldezeit verl&auml;ngern.</b>";
							var keepAliveUrl = "#buildUrl( 'rakintern:keepalive' )#";
							BootstrapDialog.show({
								title: "ACHTUNG",
								buttons: [{
									label: buttonLabel,
									action: function( dialog ) {
										$.post( keepAliveUrl );
										start=resetStartDate();
										advanceWarningFlag = 0;
										dialog.close();
									},
									cssClass: "btn-danger"
								}],
								message: warningMessage,
								type: BootstrapDialog.TYPE_WARNING,
								closable: true
							});
						}
					}else{
						location.href="#buildUrl( 'main' )#";
					}
				}
				window.setTimeout('CountDown()',100);
			</script>
		</cfif>
		<script type="text/javascript" >
			var types = 
				{	default: BootstrapDialog.TYPE_DEFAULT, 
					info: BootstrapDialog.TYPE_INFO, 
					primary: BootstrapDialog.TYPE_PRIMARY, 
					success: BootstrapDialog.TYPE_SUCCESS, 
					warning: BootstrapDialog.TYPE_WARNING, 
					danger: BootstrapDialog.TYPE_DANGER };
			var dialogMessageStart = "<ul>";
			var dialogMessageEnd = "</ul>";
			var dialogMessage ="";
			var dialogTitle = "INFORMATION";
			var dialogType = types.success;
			<cfif not arrayIsEmpty( rc.message )>
				dialogTitle = "SECURITY INFORMATION";
				dialogType = types.danger;
				<cfloop array="#rc.message#" index="msg">
					dialogMessage = dialogMessage + "#msg#";
				</cfloop>
			</cfif>		
			<cfif not arrayIsEmpty( rc.info )>
				<cfloop array="#rc.info#" index="msg">
					dialogMessage = dialogMessage + "#msg#";
				</cfloop>
			</cfif>		
			if ( dialogMessage.length ){
				dialogMessage = dialogMessageStart + dialogMessage + dialogMessageEnd;
				BootstrapDialog.alert({
					title: dialogTitle,
					message: dialogMessage,
					type: dialogType,
					closable: true
				});
			}
		</script>
	</body>
</html>
</cfoutput>
<cfsetting enablecfoutputonly="false">
