

component accessors="true" extends="BaseModifier" implements="IModifier"{

	property name="fields" type="array" default ="";
	property name="include" type="array" default ="";
	property name="exclude" type="array" default ="";

	public function init( array fields = [], array include=[], array exclude=[] ){
		super.init(argumentCollection=Arguments);
		return this;
	}

	public string function toString(){
		var json = "";
		json = arrayLen(getInclude()) ? ListAppend(json, '"include":["#arrayToStringArray( getInclude() )#"]') : json;
		json = arrayLen(getExclude()) ? ListAppend(json, '"exclude":["#arrayToStringArray( getExclude() )#"]') : json;
		if ( !len( trim( json ) ) and arrayLen( getFields() ) ) {
		}
		
		if ( len( trim( json ) ) ){
			json = '"_source":{#json#}';
		} else if ( arrayLen( getFields() ) ) {
			json = arrayToStringArray( getFields() );
			json = '"_source": #json#';
		} else {
			json = '"_source": false';
		}

		return json;
	}
}