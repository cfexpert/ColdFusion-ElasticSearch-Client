component output="false" accessors="true" displayname="helper" {
	property pagination;

	public void function setUpPagination( ){
		pagination.init();
		pagination.setShowNumericLinks( true );
		pagination.setClassName("pagination");
		pagination.setNextLinkHTML("&raquo;");
		pagination.setPreviousLinkHTML("&laquo;");
		pagination.setPreviousLinkDisabledHTML(pagination.getPreviousLinkHTML());
		pagination.setNextLinkDisabledHTML(pagination.getNextLinkHTML());
		pagination.setShowFirstLastHTML(true);
		pagination.setShowFirstLastDisabledHTML( true );
		// pagination.setFirstLinkHTML( "&lt;&lt;" );
		// pagination.setLastLinkHTML( "&gt;&gt;" );
	}

	public function getBrowseIDs( idListe, currentID ){
		var numberOfIDs = arguments.idListe.recordCount;
		var currentIDPosition = 0;
		var retval = {};
		var i = 1;
		retval["firstID"] = 0;
		retval["lastID"] = 0;
		retval["previousID"] = 0;
		retval["nextID"] = 0;
		retval["currentPosition"] = 0;
		retval["numberOfRecords"] = numberOfIDs;
		if ( numberOfIDs ){
			retval["firstID"] = val( arguments.idListe.id[1] );
			if ( numberOfIDs gt 1 ){
				retval["lastID"] = arguments.idListe.id[numberOfIDs];
			}
			for ( i=1; i lte numberOfIDs; i=i+1){
				if ( arguments.idListe["id"][i] eq arguments.currentID ){
					currentIDPosition = i;
				}
			}
			if ( currentIDPosition ){
				retval["currentPosition"] = currentIDPosition;
				if ( currentIDPosition - 1 gt 0 ){
					retval["previousID"] = arguments.idListe.id[currentIDPosition - 1];
				}
				if ( currentIDPosition + 1 lte numberOfIDs ){
					retval["nextID"] = arguments.idListe.id[currentIDPosition + 1];
				}
			}
		}
		return retval;
	}
	
	public boolean function isAJAXRequest(){
		if ( structKeyExists( getHTTPRequestData().headers , "X-Requested-With" ) ){
			return true;
		}
		return false;
	}
	
	/*
	* @hint Liefert QueryRow als Struct
	*/
	public struct function queryRowToStruct(query queryToConvert, numeric queryRowNumber ){
		var retval = {};
		var column = "";
		var currentQuery = arguments.queryToConvert;
		var currentRowNumber = arguments.queryRowNumber;
		var fields = listToArray(currentQuery.columnList);
		var numberOfColumns = arrayLen(fields);
		var i = 1;
		
		if (currentRowNumber lte currentQuery.recordCount){
			for (i=1; i lte numberOfColumns; i++){
				column = fields[i];
				retval[column] = currentQuery[column][currentRowNumber];
			}
		}
		
		return retval;
	}

	/*
	* @hint wandelt String in HEX Htmlentities um - z.B.: verschleiern von E-Mail Adressen 
	*/	
	public string function scrambleString( string stringToScramble ){
		var i = 0;
		var scrambledString = arrayNew( 1 );
		var lengthOfString = len( trim( arguments.stringToScramble ) );
		var encodedPrefix = "&##";
		var charToEncode = "";
		var encodedChar = "";
		if ( lengthOfString ){
			for( i=1; i lte lengthOfString; i=i+1 ){
				charToEncode = mid( trim( arguments.stringToScramble ), i, 1 );
				encodedChar = encodedPrefix & asc( charToEncode ) & ";";
				arrayAppend( scrambledString, encodedChar );
			}			
		}
		return arrayToList( scrambledString,"" );
	}

	public function formatNumber( unformattedNumber, mask="999,999,999.00" ){
		var formattedNumber = "";
		formattedNumber = lsNumberFormat( arguments.unformattedNumber, arguments.mask );
		return trim( formattedNumber );
	}

	public function formatInt( unformattedNumber, mask="999,999,999" ){
		var formattedNumber = "";
		formattedNumber = lsNumberFormat( arguments.unformattedNumber, arguments.mask );
		return trim( formattedNumber );
	}

	public function formatDate( unformattedDate = "", mask="DD.MM.YYYY" ){
		var formattedDate = "";
		formattedDate = lsDateFormat( arguments.unformattedDate, arguments.mask );
		return formattedDate;
	}

	public function formatDateTime( unformattedDate = "", dateMask="DD.MM.YYYY", timeMask="HH:mm:ss" ){
		var formattedDateTime = "";
		var formattedDate = lsDateFormat( arguments.unformattedDate, arguments.dateMask );
		var formattedTime = timeFormat( arguments.unformattedDate, arguments.timeMask );
		formattedDateTime = formattedDate & " " & formattedTime;
		return formattedDateTime;
	}

	public function makeDateStamp( unformattedDate = "", mask="YYYYMMDD" ){
		var formattedDate = "";
		formattedDate = lsDateFormat( arguments.unformattedDate, mask );
		return formattedDate;
	}

	public function makeDateFromDateStamp( dateStamp ){
		// wandelt timestamp im Format 20150131 in Datum/Zeit um
		var retdate = "";
		if ( len( trim( arguments.dateStamp ) ) gte 8 ){
			var thisyear = chardateyear( arguments.dateStamp );
			var thismonth = chardatemonth( arguments.dateStamp );
			var thisday = chardateday( arguments.dateStamp );
			retdate = createDate( thisyear, thismonth, thisday );
		}
		return retdate;
	}
	
	private function chardateyear ( datetoextract ){
		var extract_value = mid( datetoextract, 1, 4 );
		return extract_value;
	}
	
	private function chardatemonth ( datetoextract ){
		var extract_value = mid( datetoextract, 5, 2 );
		return extract_value;
	}
	
	private function chardateday (datetoextract){
		var extract_value = mid( datetoextract, 7, 2 );
		return extract_value;
	}

	public function makeTimeStamp( unformattedDate = "", mask="YYYYMMDDHHnnss" ){
		var formattedDate = "";
		formattedDate = lsDateTimeFormat( arguments.unformattedDate, mask );
		return formattedDate;
	}

	/*
	* @hint genieriert lesbaren Output aus comma delimited list - fuegt Leerzeichen nach Komma ein  
	*/	
	public function formatList( string listToFormat ){
		var formattedList = replace( replace( arguments.listToFormat, ", ", ",","all" ), ",",", ", "all" );
		return formattedList;
	}

  	function XHTMLParagraphFormat( string stringToReplace )	{
  		var retval = "<p>" & replace( replace( arguments.stringToReplace, "<", "&lt;", "all" ), ">", "&gt;", "all" );
  		retval = Replace(retval, chr(13) & chr(10) & chr(13) & chr(10), "</p><p>", "all");
  		retval = Replace(retval, chr(13) & chr(10), "<br />", "all");
  		retval = retval & "</p>";
  		return retval;
  	}

	public function upload( sourceFile, targetPath, nameConflict = "makeunique" ){
		var uploadResult = {};
		if ( !directoryExists( arguments.targetPath ) ){
			directoryCreate( arguments.targetPath );
		}
		uploadResult = fileUpload( arguments.targetPath, arguments.sourceFile, "", arguments.nameConflict);
		return uploadResult;
	}

	public function stripNonAsciiChars( stringToStrip ){
		var convertedString = reReplace( arguments.stringToStrip, "[^\x20-\x7E]", "", "ALL" );
		return convertedString;
	}

	public function getCSVDelimiter(){
		var csvDelimiter = ";";
		return csvDelimiter;
	}

	public function getCRLF(){
		var crlf = chr( 13 ) & chr( 10 );
		return crlf;
	}
	
	public function wrapInDoubleQuotes( termToWrap ){
		var dblQuote = chr( 34 );
		var retval = dblQuote & termToWrap & dblQuote;
		return retval; 
	}

	public function getCacheBuster(){
		var cachebuster = dateFormat( now(), "YYYYMMDD") & timeFormat( now(), "HHmmss");
		return cachebuster;
	}

	public function wrapInSingleQuotes( textToWrap ){
		var singleQuote = "'";
		return singleQuote & trim( arguments.textToWrap ) & singleQuote;
	}

	public function wrapInParagraph( termToWrap ){
		var paragraphStart = "<p>";
		var paragraphEnd = "</p>";
		var retval = paragraphStart & termToWrap & paragraphEnd;
		return retval; 
	}

	public function getDirectLinkTarget(){
		// directLink fuer Jobsuche verify
		var protocol = getProtocol();
		var retval = protocol & cgi.http_host & cgi.script_name;
		return retval;
	}

	public function getProtocol(){
		var protocol = ( val( cgi.https_keysize ) ? "https://" : "http://" );
		return protocol;
	}

	public function getClusterHealthButtonColor( status ){
		var buttonstyle = "btn-danger";
		switch ( arguments.status ) {
			case "green":
				buttonstyle = " btn-success";
				break;
			case "yellow":
				buttonstyle = " btn-warning";
				break;
			case "red":
				buttonstyle = " btn-danger";
				break;
		}
		return buttonstyle;
	}

}
