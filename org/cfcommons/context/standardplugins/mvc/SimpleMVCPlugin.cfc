import org.cfcommons.http.*;
import org.cfcommons.http.impl.*;
import org.cfcommons.context.*;
import org.cfcommons.context.impl.*;
import org.cfcommons.faceplait.impl.*;

component accessors="true" implements="org.cfcommons.context.HTTPPlugin" {

	property string defaultUrl;
	property ExceptionHandler[] exceptionHandlers;

	public SimpleMVCPlugin function init(string defaultUrl="/default/url", string viewroot="/views", 
		array exceptionHandlers=arrayNew(1), string xmlConfig) {
		
		// trace(type="information", text="SimpleMVCPlugin: initializing plugin.");
		
		variables.mapRegistry = {};
		variables.exceptionHandlers = [];
		
		// if an xml file path was provided, use it to initialize the plugin
		if (!isNull(arguments.xmlConfig)) {
			// check to see if we need to expand this file path
			local.configFilePath = fileExists(arguments.xmlConfig) ? arguments.xmlConfig : expandPath(arguments.xmlConfig);
			
			// initialize!
			initFromXmlConfig(local.configFilePath);
			return this;
		}
			
		// otherwise, we're expecting what we need in the method signature
		variables.viewroot = arguments.viewroot;
		variables.defaultUrl = arguments.defaultUrl;
		variables.exceptionHandlers = arguments.exceptionHandlers;
		
		return this;
	}
	
	public numeric function getVersion() {
		return 1.1;
	}
	
	public void function setContext(required Context context) {
		variables.context = arguments.context;	
	}
	
	public string function getResponse(string response) {
		
		// if information has already been populated in the response, then ignore it
		if (!isNull(arguments.response) && len(trim(arguments.response)))
			return response;
	
		// trace(type="information", text="SimpleMVCPlugin: Attempting to map request to a controller and method.");
		
		// if path information is not present, then revert to the default url
		if (isNull(cgi.path_info) || !len(trim(cgi.path_info)) || findNoCase(".cfm", cgi.path_info))
			local.uri = variables.defaultUrl;
		else
			local.uri = cgi.path_info;
		
		// bind all relevant data
		var args = {};
		structAppend(local.args, form);
		structAppend(local.args, url);
		structAppend(local.args, request);
				
		// simply iterate through the matchers to see if we have a winner
		for (name in variables.mapRegistry) {
			
			var map = variables.mapRegistry[name];
			
			if (local.map.matchesRequest(uri=local.uri, requestData=local.args)) {
				// trace(type="information", text="SimpleMVCPlugin: Matched...processing request.");
				
				// invoke the controller method
				var vars = map.mapRequest(uri=local.uri, requestData=local.args);
				
				// and finally, render the associated view
				return renderView(viewPath=local.map.getViewPath(), viewVariables=local.vars);
			}
			
		}

		throw(type="MVCURLMappingNotFoundException", message="Unable to match the provided URL with
			a registered controller.");
	}

	/**
	 * The SimpleMVCPlugin read method traverses the context looking
	 * for .cfc's that are intended to be MVC controllers.  When discovered,
	 * it creates URL matchers for each method in the controller with a pre-determined
	 * URL template - see documentation for more detail.  Each URL matcher is then
	 * registered with the plugin to be employed in the serviceRequest() method.
	 * Of course, this process is run only when the context is created, not
	 * on every request.
	 */
	public void function read(required any class) {
				
		var controller = false;
		
		// we're specifically looking for the following annotation
		if (class.hasAnnotation(name="cfcommons:mvc:controller"))
			var controller = true;
			
		if (findNoCase("controller", class.getShortName()))
			var controller = true;
			
		if (!controller)
			return;
		
		// strip out the world controller
		var controllerName = replaceNoCase(class.getShortName(), "controller", "", "one");
		
		// trace(type="information", text="SimpleMVCPlugin: Creating " & controllerName & " controller.");
		
		// was a view prefix defined at the class level?
		if (class.hasAnnotation(name="cfcommons:mvc:view"))
			var componentViewPrefix = class.getAnnotation(name="cfcommons:mvc:view");
		
		// we care about all methods declared on the method
		var className = arguments.class.getFullName();
		var methods = class.getMethods();
		var vRoot = variables.viewRoot;
		
		// iterate over each method
		for (var i = 1; i <= arrayLen(methods); i++) {
							
			var method = methods[i];				
							
			// we only care about public methods
			if (method.getAccess() != "public")
				continue;
			
			var methodName = method.getName();
			var mapKey = className & "." & methodName;
			
			// has this been previously registered? if so, remove it
			if (structKeyExists(variables.mapRegistry, mapKey)) {
				structDelete(variables.mapRegistry, mapKey);
			}
			
			// trace(type="information", text="SimpleMVCPlugin: Mapping " & methodName & ".");
			
			mapping = new ControllerMapping();
			mapping.setClassName(class.getFullName());
			mapping.setMethodName(methodName);
			
			// has a custom url matcher been defined?
			if (method.hasAnnotation(name="cfcommons:mvc:url")) {
				var matchTemplate = method.getAnnotation(name="cfcommons:mvc:url");
			// if no custom url was provided, we'll create a standard one based off of convention
			} else {
				var matchTemplate = "/#lcase(controllerName)#/#lcase(methodName)#";
				// make sure to create the default numeric ID matcher
				var idMatchTemplate = "/#lcase(controllerName)#/#lcase(methodName)#/{id:[0-9]+}";
			}
			
			// time to determine the view path
			if (!isNull(componentViewPrefix))
				vRoot = variables.viewRoot & componentViewPrefix;
				
			if (method.hasAnnotation(name="cfcommons:mvc:view")) {
				mapping.setViewPath(vRoot & method.getAnnotation(name="cfcommons:mvc:view"));
			// if no view annotation was declared on the method, we'll set up a default
			} else {
				mapping.setViewPath(vRoot & "/#lcase(controllerName)#/#lcase(methodName)#.cfm");
			}

			// create the default url matcher
			mapping.addURLMatcher(new SimpleURLMatcher(matchTemplate));
			
			// create a URL matcher
			var matcher = new SimpleURLMatcher();
			
			// create an index matcher if we're working with an index() method
			if (method.getName() == "index") {
				matcher.setTemplate(template="/#lcase(controllerName)#");
			// all methods other than index get a numeric id matcher
			} else if (!isNull(idMatchTemplate)){
				matcher.setTemplate(template=idMatchTemplate);
			}
			
			// add the matcher to the request map
			mapping.addURLMatcher(matcher);
			
			// needs a reference to the context
			mapping.setContext(variables.context);
			
			// register the mapping
			variables.mapRegistry[mapKey] = mapping;

		}
		
	}
	
	/**
	 * This method is externally available so as to allow other plugins
	 * to ask the MVC plugin to execute according to a registered 
	 * exception handler.  If an exception handler is not being managed by
	 * this plugin provided the given "type", then an exception will be 
	 * thrown indicating that the handler does not exist.
	 *
	 * See the renderView() documentation for information on the "hardStop" flag.
	 */
	public void function throwException(required string type, required any exception, boolean hardStop=false) {
		// run the exception handler
		var handler = getExceptionHandler(arguments.type);
		
		var instance = variables.context.getObjectInstance(class=handler.getClass());
		
		var args = {};
		// exception handlers are expecting an argument named "exception"
		args.exception = arguments.exception;
		evaluate("instance.#handler.getMethod()#(argumentCollection=args)");
					
		// now render the view
		return renderView(viewpath=handler.getView(), 
			viewVariables=args, hardStop=arguments.hardStop);	
	}
	
	private string function renderView(required string viewpath, struct viewVariables=structNew()) {
	
		// trace(type="information", text="SimpleMVCPlugin: Rendering view.");
		
		// before we simply render the view path, let's check to see if a view variable has been defined
		if (structKeyExists(arguments.viewVariables, "view")) {
			arguments.viewpath = variables.viewRoot & "/" & arguments.viewVariables.view;
		}
	
		local.page = new HTMLPage(filePath=arguments.viewpath, 
			pageVars=arguments.viewVariables);
		
		return local.page.getContents();
	}
	
	/**
	 * This registry is purely temporary - as we'll take the contents 
	 * and add them to the context on Finalize.
	 */
	public void function addExceptionHandler(required ExceptionHandler handler) {
		arrayAppend(variables.exceptionHandlers, arguments.handler);
	}
	
	public void function finalize() {
		// iterate through and add these exception handlers to the parent context
		for (var i = 1; i <= arrayLen(variables.exceptionHandlers); i++) {
			var handler = variables.exceptionHandlers[i];
			// trace(type="information", text="SimpleMVCPlugin: Registering exception handler of type #handler.getType()# with the parent context.");
			variables.context.addExceptionHandler(handler);
		}
		
		// now delete the exceptionHandlers registry
		structDelete(variables, "exceptionHandlers");
	}
	
	public void function postContextConstruct() {}
	
	private void function initFromXmlConfig(required string xmlFilePath) {
	
		var myfile = fileOpen(arguments.xmlFilePath, "read"); 
		var xmlfile = fileRead(myfile, 10000);
		xmlfile = xmlParse(xmlfile);
		fileClose(myfile);
		
		// first grab the default-url and view-root configurations
		var defaultUrl = xmlFile["simple-mvc"]["default-url"].xmlText;
		var viewRoot = xmlFile["simple-mvc"]["view-root"].xmlText;
		
		// now iterate through and grab each exception handler
		var handlers = xmlFile["simple-mvc"]["exception-handlers"].xmlChildren;
		
		/*
		 * All we're going to do is create and register some 
		 * BasicExceptionHandlers with the parent context.
		 */
		var i = 1;
		for (; i <= arrayLen(handlers); i++) {
			var handler = handlers[i];
			var instance = new BasicExceptionHandler();
			
			instance.setType(handler.xmlAttributes.type);
			instance.setClassName(handler.xmlAttributes.class);
			instance.setMethodName(handler.xmlAttributes.method);
			instance.setViewTemplate(handler.xmlAttributes.view);
			
			// now register the new handler internally - we'll use this array on finalize()
			addExceptionHandler(instance);
		}
		
		// make sure to set the default URL and the view root
		variables.defaultUrl = defaultUrl;
		variables.viewRoot = viewRoot;
			
	}

}