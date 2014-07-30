component
{
	
	this.name = "GGS";
	this.root = getdirectoryfrompath(getcurrenttemplatepath());
	this.root = replace(this.root, listlast(this.root, "\") & "\", "");	
	request.app = {};
	request.app.name = "GGS";
	request.app.http_host = cgi.http_host;
	request.app.url.site = "http://" & request.app.http_host;
	request.app.root = getApplicationRootPath();	
	request.app.asset = request.app.root & "asset\";
	request.app.compatible = checkBrowser();

	request.mail.server = "localhost";
	request.mail.username = "";
	request.mail.password = "";
	request.mail.port = "25";
	request.mail.ssl = false;
	
	request.account.processor = "Stripe";
	
	if (cgi.server_port_secure)
		request.app.http = "http://";
	else
		request.app.http = "http://";
		
	request.stripe.api.testKey = "";
	request.stripe.api.liveKey = "";	
	
	// orm
	this.ormenabled = "true";//     enable hibernate support for this application
	this.ormsettings = {};// create a struct of ORM settings
	this.ormsettings.eventhandling = "false";// turn on event handling
	this.ormsettings.LogSQL = "false";// turn on SQL logging
	this.ormsettings.secondarycacheenabled = "false";
	this.ormsettings.cacheprovider = "ehcache";
	// this.ormsettings.dialect = "MySQL";
	this.ormsettings.dialect = "MicrosoftSQLServer";
	cfcarray = [];
	arrayappend(cfcarray, "/shared/model/");
	this.ormsettings.cfclocation = cfcarray;
	
	if(!isnull(url.createDb)){
		this.ormSettings.dbCreate = "dropcreate";
		this.ormsettings.sqlscript = "sql.sql";
		writeoutput("DB Created...");
	}
	
		
	public function onRequestStart(){

		if(!isnull(url.reload))
			initApp();
		
		if (!isnull(url.docs))
			generateColdDocs();
		
		request.ip = application.invoke.IpAddress().ip(cgi.REMOTE_HOST).friendlyIp();	
		
		if ( isnull(session.user) && structkeyexists(application,"context") || isdefined("url.reload"))
			application.context.ioc.getObjectInstance(class="shared.model.security.SessionManager").startSession();
		
		if(listlast(cgi.PATH_INFO, ".") == "json")
			application.context.rest.respond();
		else if (listlast(cgi.PATH_INFO, ".") == "cfc")			
			request.remote = true;
		else
			application.context.mvc.respond();
	}
	
	public function onApplicationStart(){
		application.jarroot = "/shared/model/util/jar/";
		initApp();		
	}
	
	public void function initApp(){
		clearContext();
		reloadORM();
		createContext();					
	}
	
	/**
	* @hint I clear the the application context and force jvm garbage collection
	*/
	private void function clearContext(){	
		if ( structkeyexists(application, "context") ) 
			structdelete(application, "context");
		initGarbageCollection();					
	}
	
	/**
	* @hint I create a new application context
	*/
	private void function createContext(){					
		import org.cfcommons.context.impl.*;
		import org.cfcommons.context.standardplugins.event.*;
		import org.cfcommons.context.standardplugins.mvc.*;
		import org.cfcommons.context.standardplugins.rest.*;
		import org.cfcommons.context.standardplugins.faceplait.FaceplaitPlugin;
		import org.cfcommons.context.standardplugins.ioc.*;
		import org.cfcommons.context.standardplugins.aop.*;
		
		application.context = {};
		application.context.mvc = new HTTPContext(root=expandPath("/controller/"));
		
		
		var aopPlugin = new SimpleAOPPlugin();
		var mvcPlugin = new SimpleMVCPlugin(defaultUrl="index.cfm/home/index", viewRoot="/");		
		var faceplaitPlugin = new FaceplaitPlugin(layoutsDirectory="/view/layout/");
		application.context.mvc.addPlugin(mvcPlugin);
		application.context.mvc.addPlugin(faceplaitPlugin);
		var event = new ImplicitEventsPlugin();
		application.context.mvc.addPlugin(event);
		application.context.mvc.addPlugin(aopPlugin);		
		application.context.mvc.finalize();
				
		application.context.rest = new HTTPContext(root=expandPath("/controller/"));
		var powernap = new PowernapPlugin();
		application.context.rest.addPlugin(powernap);
		var event = new ImplicitEventsPlugin();
		application.context.rest.addPlugin(event);
		application.context.rest.addPlugin(aopPlugin);
		application.context.rest.finalize();
	
		application.context.ioc = new PluggableContext(root=expandPath("/shared/"));
		var neodymium = new NeodymiumPlugin();
		application.context.ioc.addPlugin(neodymium);
		application.context.ioc.finalize();
		application.invoke = application.context.ioc.getObjectInstance(class="shared.model.Invoke");						
	}
	
	/**
	* @hint I tell Coldfusion to regenerate all the ORM mappings
	*/
	private void function reloadORM(){
		try {			
			initGarbageCollection();						
			ORMReload();
			sleep(1000);				
		}
		catch(any e){
			// orm locked try again... 
			sleep(2000);
			ORMReload();
		}		
	}
	
	/**
	* @hint I tell the Coldfusion JVM to collect garbage
	*/
	private void function initGarbageCollection(){
		var obj = createObject("java","java.lang.System");    
    	obj.gc();    
    	obj.runFinalization();
    	sleep(2000);		
	}
		
	/**
	* @hint I generate colddocs documentation
	*/
	private void function generateColdDocs(){
		var colddoc = createObject('component', 'colddoc.ColdDoc').init();
		var strategy = createObject('component', 'colddoc.strategy.api.HTMLAPIStrategy').init(this.root & "app\colddoc\docs", 'CFSN - GoGreenSocial - API');
		colddoc.setStrategy(strategy);
		var paths = [
					{inputDir=this.root & "shared", inputMapping="shared"},
			        {inputDir = this.root & "app\ggs", inputMapping = "app/ggs"}
			        ];
		colddoc.generate(paths);
	
		writeoutput("<br>ColdDoc Generated...");
	}
	
	/**
	* @output false
	*/
	public any function getApplicationRootPath(string basePath="./"){
		var thisPath = ExpandPath(arguments.basePath);
		if ( fileExists(ExpandPath(arguments.basePath & "Application.cfc"))) {
			return thisPath;
		}		
		else if ( REFind('.*[/\\].*[/\\].*', thisPath )) {
			return getApplicationRootPath("../#arguments.basePath#");
		}			
		else {
			throw(message="Unable to determine the app root" detail=thisPath);
		}								
	}
	
	public string function checkBrowser(){
		request.browser = 'modern';			
		if (FindNoCase('MSIE 6','#CGI.HTTP_USER_AGENT#') GREATER THAN 0 AND FindNoCase('Opera','#CGI.HTTP_USER_AGENT#') LESS THAN 1)
	  		request.browser = 'suck';	  	
	  	if (FindNoCase('MSIE','#CGI.HTTP_USER_AGENT#') && !FindNoCase('MSIE 9','#CGI.HTTP_USER_AGENT#'))
	  		request.browser = 'suck';	  	
	  	if (request.browser == "suck"){
	  		// writeoutput("-");
	  		return "please upgrade your browser.  You'll be happy you did!";
	  		return "<center><h2 style=color:red;>your browser is very old... Please update for a better web experience...</h2></center>";
	  	}
	  						
		return request.browser;
	}
	
	
}