import org.cfcommons.faceplait.*;
import org.cfcommons.faceplait.util.*;

component accessors="true" implements="org.cfcommons.faceplait.ViewFactory" {

	property DirectoryReader reader;
	
	variables.installLayout = '<html></head><title><plait:title /></title><style type="text/css">.faceplait{font-family:
		calibri;}</style><plait:head /></head><body><table border="1" cellpadding="5"><tr><td class="faceplait">
		<h2>Faceplait is decorating this page with a layout.</h2>Please consult the Faceplait documentation in order
		to provide your own custom layout for this page.</td></tr><tr><td><plait:body /></td></tr>
		</table></body></html>';

	public HTMLViewFactory function init() {
		variables.layouts = {};
		return this;
	}
		
	public View function getView(required Page page, Layout layout) {
	
		/**
		 * First things first - if the page has explicitly called out
		 * a layout in it's markup, then let's use that
		 */
		local.layoutName = page.getLayoutName();
		
		if (isNull(arguments.layout) && page.hasLayoutMarker() && 
			structKeyExists(variables.layouts, local.layoutName)) {
		
			// ensure thread safety
			local.cachedLayout = variables.layouts[layoutName];
			local.layout = new HTMLLayout();
			layout.setContents(local.cachedLayout.getContents());
			
		// if NONE was specified for layout name, then don't use anything
		} else if (layoutName == "NONE") {
			// simply return the unaltered page
			return page;
		} else if (isNull(arguments.layout)) {
			// otherwise, if the layout is simply not provided, then use the default
			local.layout = new HTMLLayout();
			local.layout.setContents(variables.installLayout);
		}
				
		// first replace title information
		local.title = page.getTitleContent();
		local.layout.replaceTitleMarker(title);
		
		// now head
		local.head = page.getHeadContent();
		local.layout.replaceHeadMarker(head);
		
		// finally body
		local.body = page.getBodyContent();
		local.layout.replaceBodyMarker(body);
				
		return local.layout;			
	}
	
	public void function setLayoutsDirectory(required string layoutsDirectory) {
		
		// if the directory argument is already an absolute path, use it
		if (directoryExists(arguments.layoutsDirectory))
			local.directoryPath = arguments.layoutsDirectory;
		else
			local.directoryPath = expandPath(arguments.layoutsDirectory);
			
		// final check
		if (!directoryExists(local.directoryPath)) {
			throw(type="InvalidDirectoryPathException", message="Unable resolve directory path '#directoryPath#'.");
		}
		
		local.contents = directoryList(local.directoryPath, false);
						
		// iterate throught the contents and create a new cached layout for each file
		local.i = 1;
				
		for (; local.i <= arrayLen(local.contents); local.i++) {
			
			local.entryPath = local.contents[local.i];
			
			// we only care about files with a .cfm extension - everything else gets ignored
			if (!find(".cfm", local.entryPath))
				continue;
			
			local.file = "";
			local.path = getRelativePath(local.entryPath);
												
			// we need to make sure that we include the path, in case there are any cfincludes
			savecontent variable="local.file" {
				include path;		
			}
			
			local.layout = new HTMLLayout();
			local.layout.setContents(local.file);
			local.name = replace(listLast(local.entryPath, "\"), ".cfm", "");
			variables.layouts[name] = local.layout;
		}
	}
	
	private string function getRelativePath(required string absolutePath) {
	
		local.path = replaceNoCase(arguments.absolutePath, expandPath("/"), "", "one");
		local.path = replace(local.path, "\", "/", "all");
		local.path = "/" & local.path;
		
		return local.path;
	}

}