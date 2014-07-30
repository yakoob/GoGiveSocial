import org.cfcommons.faceplait.*;
import org.cfcommons.faceplait.impl.*;
import org.cfcommons.context.*;

component accessors="true" implements="org.cfcommons.context.HTTPPlugin" {

	property ViewFactory viewFactory;

	public FaceplaitPlugin function init(required string layoutsDirectory) {
		// trace(type="information", text="FaceplaitPlugin: initializing plugin.");
		
		// this plugin maintains an internal reference to an HTMLViewFactory
		variables.viewFactory = new HTMLViewFactory();
		
		// optional initialization and conifiguration via an xml file
		if (!directoryExists(arguments.layoutsDirectory))
			arguments.layoutsDirectory = expandPath(arguments.layoutsDirectory);
			
		// check again
		if (!directoryExists(arguments.layoutsDirectory)) {
			throw(type="InvalidConfigFilePath", message="Unable to initialize the FaceplaitPlugin",
				detail="The layouts directory is not valid: #arguments.layoutsDirectory#.");
		}
		
		variables.viewFactory.setLayoutsDirectory(arguments.layoutsDirectory);
		
		return this;
	}
	
	public void function setContext(required Context context) {};
	
	/**
	 * We're going to decorate the previous response.
	 */
	public string function getResponse(string response) {
	
		if (!shouldFilterResponse(response=arguments.response)) {
				/*
				trace(type="information", text="FaceplaitPlugin: Sorry, I won't filter response 
				types consisting of JSON or XML data.");
				*/
			return arguments.response;
		}
	
		// trace(type="information", text="FaceplaitPlugin: Filtering response.");
	
		local.page = new HTMLPage();
		local.page.setContents(arguments.response);
				
		// we'll use the internal layouts registry to determine which layout to use		
		local.view = getViewFactory().getView(page=local.page);
					
		return local.view.getContents();
	}
	
	private boolean function shouldFilterResponse(required string response) {
		
		if (isHtml(arguments.response))
			return true;
			
		if (!len(trim(arguments.response)))
			return false;
		
		// we'll decorate responses that are NOT JSON or XML
		if (isJson(arguments.response))
			return false;
			
		if (isXML(arguments.response))
			return false;
		
		return true;
	}
	
	public boolean function isHtml(required string string) {
		if (refindNoCase("<html>|</html>", arguments.string))
			return true;
			
		return false;
	}
	
	public numeric function getVersion() {
		return 1.0;
	}

	// not needed
	public void function read(required any class) { }
	
	// not needed
	public void function finalize() {}
	
	// not needed
	public void function postContextConstruct() {}

}