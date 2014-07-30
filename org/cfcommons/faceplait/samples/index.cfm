<cfscript>
	import org.cfcommons.faceplait.*;
	import org.cfcommons.faceplait.impl.*;
	import org.cfcommons.faceplait.util.*;
	
	// cache for testing purposes		
	if (!isDefined("application.viewFactory") || isDefined("url.reinit")) {
	
		application.viewFactory = new HTMLViewFactory();
		application.viewFactory.setLayoutsDirectory(expandPath("/org/cfcommons/faceplait/samples/layouts/"));
		
	}
	
	page = new HTMLPage("/org/cfcommons/faceplait/samples/test_page.cfm", {testvariable="Hello World", form.bleh='blah'});
	layout = new HTMLLayout("/org/cfcommons/faceplait/samples/layouts/sample_layout_3.cfm");
	
	view = application.viewFactory.getView(page=page);
	
	// write the modified view
	writeOutPut(view.getContents());		
	
</cfscript>