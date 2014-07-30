component accessors="true" implements="org.cfcommons.faceplait.View" {

	property string contents;
	
	public function init() {
		throw(type="AbstractInstantiationException", message="Cannot directly instantiate this abstract class.");
	}

	/**
	 * Reads in the specified vale at the filepath location, optionally passing
	 * in (making available) page variables that can be referenced as local variables
	 * on the page.
	 */
	public void function parseContents(string filepath, struct pageVars=structNew()) {
		local.contents = "";
		
		savecontent variable="local.contents" {
			structAppend(variables, arguments.pageVars);
			include arguments.filePath;
		}
		
		variables.contents = local.contents;
	}

	public string function getContents() {
		return isNull(variables.contents) ? "" : variables.contents;
	}

}