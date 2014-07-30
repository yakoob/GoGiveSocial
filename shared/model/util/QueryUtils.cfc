/**
* @extends shared.model.Object
* @displayname QueryUtils
*/
component{
	
	/**
	* @hint I accept a query and return an array of structures
	*/
	public array function queryToArray( required query query ) {
		var columns = ListToArray( arguments.query.columnList );
		var rows = [];
		
		for ( var i=1; i<=query.recordCount; i++ ) {
			var row = {};
			for ( var j=1; j<=ArrayLen( columns ); j++ ) {
				var columnName = columns[ j ];
				row[ columnName ] = arguments.query[ columnName ][ i ];	
			}
			ArrayAppend( rows, row );			
		}
		
		return rows;
	}; 
	
}
