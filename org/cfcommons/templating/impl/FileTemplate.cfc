import org.cfcommons.templating.*;

/**
 * The contents of this template are initialized by a system file
 * whose path must be provided in the constructor.  Template file
 * encoding may be optionally provided otherwise UTF-8 is assumed.
 */
component extends="org.cfcommons.templating.impl.StringTemplate" {
		
	/**
	 * Initializes the template with the contents of a specified file provided
	 * in the templatePath argument.  Optionally accepts an argument named
	 * "encoding" to specify file encoding type.  Default is "UTF-8".  File
	 * type is not considered - can be anything that the CF native fileRead()
	 * function can accept.
	 *
	 * If the system file at the provided path does not exist then an
	 * exception of type InvalidTemplateFilePathException will be thrown.
	 */
	public Template function init(required string templatePath, string encoding="UTF-8") {
	
		if (!fileExists(arguments.templatePath)) {
			throw(type="InvalidTemplateFilePathException", message="Cannot create a file template with an invalid path", 
				detail="The file at #arguments.templatePath# does not exist.");
		}
	
		var content = fileRead(arguments.templatePath, arguments.encoding);
		return super.init(content=content);
	}
	
}