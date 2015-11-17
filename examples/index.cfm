<cfheader name="Expires" value="#GetHttpTimeString(Now())#">
<cfheader name="Pragma" value="no-cache">
<cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
<cfoutput><!DOCTYPE html> 
<html>
	<head>
		<title>ElasticSearch CFML Client Example</title>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<meta name="robots" content="noindex">
		<meta name="author" content="">
		<meta name="description" content="">
	</head>

	<body>
		<div id="wrap">
			<h1>ElasticSearch CFML Client Example</h1>
			<div>
				<cfscript>
					getResponse = { "status" : "empty Response" };
					config = [ { host="localhost", port="9200", path="", secure=false, username="", password="" } ];
					clusterManager = new lib.ClusterManager( config );
					// writeDump( var=clusterManager );
					es = new lib.ElasticSearchClient( clusterManager );
					// writeDump( var=es );
					// Example GET Request
    				// getResponse = es.prepareGet( "twitter","tweet","5" ).execute();
    				// getResponse = es.prepareGet( "documents","document","115" ).execute();
    				// getResponse = es.prepareGet( "bank","account","10" ).execute();
    				// tweetBody = '{ "user" : "cfexpert", "post_date" : "#getIsoTimeString( now() )#", "message" : "mind the monster" }';
    				// basic search
    				searchJSON = '{
						  "_source": [ "filen*", "fileu*" ],
						  "query": {
						    "match": {
						      "file.content": "sysmex"
						    }
						  },
						  
						  "highlight": {
						    "fields": {
						      "file.content": {
						      }
						    }
						  }
						}';
    				// getResponse = es.prepareRequest( "plasmasops/sop/_search", "POST", searchJSON ).execute();
    				
    				// create index
    				// getResponse = es.prepareIndex("plasmasops").execute();

    				// example MAPPING
    				// currently not functional
    				// mapping =  { "sop" : { "properties" : { "sopcontent" : { "type" : "attachment" } } } };
    				// { { "sop": { "properties": { "file": { "type": "attachment", "content": { "file": { "type": "string",  "term_vector":"with_positions_offsets",  "store": true } } } } } }
     				// getResponse = es.prepareMapping("documents","document", mapping ).execute();

    				// example POST/PUT Requests
    				// this works without specifying id:
    				// prepareRequest = es.prepareRequest( "twitter/tweet", "POST", tweetBody ).execute();
    				
    				// this also works with id provided
    				// getResponse = es.prepareIndex("twitter","tweet","7").setBody(tweetBody).execute();

    				// example DELETE
    				// delete index
    				// getResponse = es.prepareDelete( "bank" ).execute();
    				// delete document by id
    				// getResponse = es.prepareDelete( "plasmasops", "sop", "299" ).execute();
    				
    				// example GET
    				// getResponse = es.prepareGet( "documents","document","3" ).execute();
    				// getResponse = bulkDelete();
    				
    				// example Query / Search
    				// getResponse = sendQuery();
    				
    				function sendQuery(){
	    				var searchTerm = "organisatori%";
	    				var index = "plasmasops";
	    				var type = "sop";
	    				var fieldsToSearch = "file.content,filename,_id";
	    				var fieldToSearch = "file.content";
	    				var qb = es.queryBuilder();
						var searchQuery =qb.MultiMatchQuery( fieldsToSearch, searchTerm );
						//var searchQuery =qb.MatchQuery( fieldToSearch, searchTerm );
						var highlightField = new lib.search.modifiers.HighlightField( "file.content" );
						var highlightModifier = new lib.search.modifiers.HighlightModifier( [highLightField] );
						var sourceModifier = new lib.search.modifiers.SourceModifier( [ "filen*", "fileu*" ] );
						// writeDump( var=searchQuery, abort=true);
						var getResponse = es.prepareSearch( index )
											.setTypes( type )
											.setQuery( searchQuery )
											.setModifiers( [highlightModifier,sourceModifier] )
											.setFilters([])
											.setFrom(0)
											.setSize(20)
											.execute();
						return getResponse.getBody();
    				}



    				// Dokumente
    				documentPath = "D:/CFUSION/Apps/rak_development/dokumente/";
    				fileToRead ="PLAMORE_Doku.pdf";
    				absolutePathToFile = documentPath & fileToRead;
    				if ( 0 and fileExists( absolutePathToFile ) ){
	    				fileToIndex = fileReadBinary( absolutePathToFile );
	    				fileInBase64Format = binaryEncode( fileToIndex, "Base64" ); // toBase64( fileToIndex );
	    				sopBody = '{ "filename" : "#fileToRead#", "file" : "#fileInBase64Format#" }';
	    				getResponse = es.prepareIndex("plasmasops", "sop", "299").setBody(sopBody).execute();
    				}
    				
    				/* documentBody = '{"documentname" : "documentname", 
    									"originaldocumentname" : "originaldocumentname",
    									"documenttitle" : "documenttitle",
    									"documentnumber" : "documentnumer",
    									"documentordinary" : "documentordinary",
    									"source" : "source",
    									"content" : "content",
    									"tags" : "tags",
    									"test" : "Testentry",
    									"datecreated" : "2015-11-14T11:08:12",
    									"relevancedate" : "2015-11-14T11:08:12" }';*/

    				// getResponse = es.prepareIndex("documents","document","2").setBody(documentBody).execute();

    				// create index from database

					// documentPath = "D:/Install/Plaamor/SOPsDraft/SOPs/"; // pdf path
					

    				// getResponse = bulkDelete();

    				// RAK Dokumente
    				// getResponse = indexRakDokumente();
    				
    				// SOP Fulltext 
    				// getResponse = indexSops();
    				
    				writeDump( var=getResponse );

    				public function indexSOPs(){
    					var documentPath = "D:\Install\Plaamor\SOPsDraft\SOPsBasisForTranslation/"; // word path
						var availableDocuments = crawlDocuments( documentPath );
						var getResponse = indexDocuments( availableDocuments );
						return getResponse;
    				}

    				public function crawlDocuments( path ){
    					var dirList = directoryList( arguments.path, true, "query"  );
    					var i = 1;
    					var filesFound = [];
    					var fileFound = "";
    					var docCounter = 30001;
    					for ( i=1; i lte dirList.recordCount; i=i+1){
    						if ( dirList["type"][i] eq "file" ){
    							fileFound = dirList["directory"][i];
    							arrayAppend( filesFound, { "fileName"=dirlist["name"][i], "absolutePathToFile"=fileFound, id=docCounter } );
    							docCounter = docCounter + 1;
    						}
    					}
    					return filesFound;
    				}

    				public function indexDocuments( availDocs ){
    					var getResponse = "";
    					var allResponses = [];
    					var i = 1;
    					for ( i = 1; i lte arrayLen(arguments.availDocs); i = i + 1 ) {
    						getResponse = storeSOPInElasticSearch( arguments.availDocs[i] );
    						arrayAppend( allResponses, getResponse );
    					}
    					return allResponses;
    				}

    				public function storeSOPInElasticSearch( doc ){
	    				var fileToIndex = "";
	    				var fileInBase64Format = "";
	    				var sopBody = "";
	    				var getResponse = "";
	    				var id = arguments.doc.id;
	    				var fileName = arguments.doc.fileName;
	    				var absolutePathToFile = arguments.doc.absolutePathToFile & "/" & arguments.doc.fileName;

	    				if ( fileExists( absolutePathToFile ) ){
		    				fileToIndex = fileReadBinary( absolutePathToFile );
		    				fileInBase64Format = binaryEncode( fileToIndex, "Base64" ); // toBase64( fileToIndex );
		    				sopBody = '{ 
		    								"filename" : "#fileName#", 
		    								"fileurl" : "#urlEncodedFormat(absolutePathToFile)#", 
		    								"file" : "#fileInBase64Format#"
		    								 }';
		    				getResponse = es.prepareIndex("plasmasops", "sop", "#id#").setBody(sopBody).execute();
	    				}
	    				return getResponse;
    				}

 	  				// RAK Dokumente
 	  				public function indexRakDokumente(){
    					var getData = getDocuments();
    					var getResponse = storeDocumentsInElasticSearch( getData );
						return getResponse;
    				}
 
 					public function getDocuments(){
						var qry = new Query();
						var queryResult = "";
						var qryString = "
							SELECT *
							FROM doc_dokumente";
						qry.setDatasource("rgb_rak");
						qry.setSQl(qryString);
						queryResult = qry.execute().getResult();
						return queryResult;
					}
					
					public function storeDocumentsInElasticSearch( documents ){
						var documentbody = "";
						var docs = arguments.documents;
						var i = 1;
						var result = [];
						var itemResult = "";
						var filePath = "D:\CFUSION\Apps\rak_development\dokumente\";
						var binFileBase64 = "";
						var binFileContent = "";
						var currentDocumentFile = "";
						var fileAvailable = false;
						if ( arguments.documents.recordCount ){
							for ( i=1; i lte arguments.documents.recordCount; i=i+1 ){
								currentDocumentFile = filePath & trim( docs.dokumentname[i] );
								if ( fileExists( currentDocumentFile ) ){
									binFileContent = fileReadBinary( currentDocumentFile );
									binFileBase64 = toBase64( binFileContent );
									fileAvailable = true;
								} else {
									fileAvailable = false;
									binFileBase64 = "";
								}
								documentBody = '{ 	"documentname" : "#stripCtrlChars(docs.dokumentname[i])#", 
									"originaldocumentname" : "#stripCtrlChars(docs.dokumentoriginalname[i])#",
									"documenttitle" : "#stripCtrlChars(docs.dokumenttitel[i])#",
									"documentnumber" : "#stripCtrlChars(docs.dokumentnummer[i])#",
									"documentordinary" : "#stripCtrlChars(docs.dokumentzahl[i])#",
									"source" : "#stripCtrlChars(docs.quelle[i])#",
									"binfile" : "#binFileBase64#",
									"shortdescription" : "#stripCtrlChars(docs.memo[i])#"
									}';
    							itemResult = es.prepareIndex("documents", "document", docs.iddokument[i]).setBody(documentBody).execute();
    							itemResult["savedBody"] = docs.iddokument[i] & " | " & docs.dokumenttitel[i] & " " & docs.dokumentname[i];
    							if ( fileAvailable ){
    								itemResult["fileFount"] = docs.dokumentname[i];
    							} else {
    								itemResult["fileFount"] = "";
    							}
    							arrayAppend( result, itemResult);
							}
						}
						return result;
					}

    				// bulk deletion
    				public function bulkDelete(){
    					var fromID = 20000;
    					var toID = 20030;
    					var i=fromID;
    					var allResponses = [];
    					var getResponse = "";
    					for ( i=fromID; i lte toID; i=i+1){
    						getResponse = es.prepareDelete( "plasmasops", "sop", "#i#" ).execute();
    						arrayAppend( allResponses, getResponse );
    					}
    					return allResponses;
    				}
					
					// misc functions
					private function stripCtrlChars( stringToStrip ){
						return reReplace( arguments.stringToStrip, "[^0-9A-Za-z\.\-:;=,_ ]","","all" );
					}

					private function stripCtrlCharsNew( stringToStrip ) {
						return reReplace( arguments.stringToStrip, "[^\x20-\x7E]", "", "ALL" ); // 0x20=space, chr(32); \0x7E = ~ / tilde, chr(126)
					};

					private string function getIsoTimeString(
						required date datetime,
						boolean convertToUTC = true ) {
						if ( convertToUTC ) {
							datetime = dateConvert( "local2utc", datetime );
						}
						// When formatting the time, make sure to use "HH" so that the
						// time is formatted using 24-hour time.
						return(
						    dateFormat( datetime, "yyyy-mm-dd" ) &
						    "T" &
						    timeFormat( datetime, "HH:mm:ss" ) &
						    "Z"
						);
					}
				</cfscript>	
			</div>
			
		</div>

		<div id="footer">
			<div class="container">
				<div class="row">
					<div class="col-md-8 col-md-offset-2">
						ElasticSearch CFML Client Example &bull; #application.appVersion# &bull; #dateFormat(now(),"DD.MM.YYYY")# #timeFormat(now(),"HH:mm:ss")# - &copy; 2014 - #year(now())# &bull; <a href="http://www.atginfotech.com" title="ATGInfotech" target="_blank">ATGInfotech</a>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>
</cfoutput>
