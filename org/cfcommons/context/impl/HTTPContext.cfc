import org.cfcommons.context.*;
import org.cfcommons.context.impl.*;

component extends="org.cfcommons.context.impl.PluggableContext"
	implements="org.cfcommons.context.HTTPContext" {

	/**
	 * An HTTPContext will (hopefully) contain any number of both vanilla
	 * and HTTPPlugin implementations.  It's this classes job to iterate
	 * through each.
	 */
	public void function respond() {
		var response = "";
		
		// iterate through each plugin to see if any are HTTPPlugins - filter the response as we go.
		for (var i = 1; i <= arrayLen(variables.plugins); i++) {
			// one at a time grab
			var plugin = variables.plugins[i];
			
			// if this is an httpPlugin
			if (!isInstanceOf(plugin, "org.cfcommons.context.HTTPPlugin"))
				continue;
				
			// we're going to try/catch this
			try {
				response = plugin.getResponse(response);
			} catch(Any e) {
				// is there a registered exception handler for this problem?
				if (super.hasExceptionHandler(type=e.type)) {
					runExceptionHandler(super.getExceptionHandler(type=e.type), e);
				// next, was a type of "Any" registered - this is a catch-all
				} else if (super.hasExceptionHandler(type="Any")) {
					runExceptionHandler(super.getExceptionHandler(type="Any"), e);
				// if not - rethrow
				} else {
					rethrow;
				}
			}
				
		}
		
		// delegate to this method to push the actual content out
		renderToClient(response);
		
		// trace(type="information", text="HTTPContext: Response complete.");
	}
	
	private void function runExceptionHandler(required ExceptionHandler handler, required any exception) {
	
		var type = arguments.handler.getType();
		// trace(type="information", text="HTTPContext: Caught exception of type #type#, handling..");
		
		// automatically creates a proper instance
		var instance = super.getObjectInstance(arguments.handler.getClassName());
		
		var args = {};
		args.exception = arguments.exception;
		evaluate("instance.#arguments.handler.getMethodName()#(argumentCollection=args)");
		
		// finally render the associated template
		var handlerView = readExceptionHandlerTemplate(arguments.handler.getViewTemplate(), args);
		
		renderToClient(handlerView);
		
		// if this is an exception template - then processing stops here
		abort;
	}
	
	private string function readExceptionHandlerTemplate(required string filepath,
		struct viewVariables=structNew()) {
		
		// trace(type="information", text="HTTPContext: Rendering exception handler view template.  Processing aborted.");
		
		var content = "";
		savecontent variable="content" {
			// read in the controller variables so their available to the view
			structAppend(variables, arguments.viewVariables);
			include arguments.filepath;
		}
		
		// we like faceplait - and we'll play nice with it if it exists as a plugin within the context
		if (super.hasPlugin("org.cfcommons.context.standardplugins.faceplait.FaceplaitPlugin")) {
			// decorate the error view with a layout
			var faceplaitPlugin = super.getPlugin("org.cfcommons.context.standardplugins.faceplait.FaceplaitPlugin");
			content = faceplaitPlugin.getResponse(content);
		}
		
		return content;	
	}
	
	private void function renderToClient(required string response) {
		// simply pushes the response
		writeOutPut(response);
	}

}