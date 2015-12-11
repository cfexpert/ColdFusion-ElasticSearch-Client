<cfparam name="jumpTarget" default="">
<cfoutput>
	<cfif rc.isAjaxRequest eq false>
		</div>
		<!-- Preloader -->
		<div id="preloader">
			<div id="preloaderstatus">&nbsp;</div>
		</div>
		<script type="text/javascript">
			$(document).ready(function() {
				removePreloader( );
				$("##mainarea").on('click', ".pagination a", function( e ){
					var href = $(this).attr('href');
					reloadContent( href );
					e.preventDefault();
				});
							
			});
			
			function removePreloader( ){
				$('##preloaderstatus').fadeOut(); // will first fade out the loading animation
				$('##preloader').delay(350).fadeOut('slow'); // will fade out the white DIV that covers the website.
				$('body').delay(350).css({'overflow':'visible'});
			}
			
			function reloadContent( newlink ){
				var loadTarget = $("##mainarea");
				$('##preloader').fadeIn();
				$('##preloaderstatus').fadeIn();

				loadTarget.load( newlink, function( data ){
					loadTarget.html( data );
					loadTarget.animate( {opacity:10} );
					removePreloader();
				} );
			}
		</script>	
	</cfif>
</cfoutput>
