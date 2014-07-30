import org.cfcommons.context.*;

component accessors="true" implements="org.cfcommons.context.ObjectDecorator" {

	property Context context;
	property struct annotationMarkers;
	property array exemptTypes;
	
	public AutowiringObjectDecorator function init() {
		setExemptTypes(["string", "boolean", "uuid", "struct", "array", "numeric", "binary", "component", "guid", "query", "xml", "date"]);
		return this;
	}
	
	public any function decorate(required any object, required string className) {
		
		// make sure that the context is managing the requested class
		if (!variables.context.hasClass(arguments.className)) {
			throw(type="InvalidWiringContextType", message="AutowiringObjectDecorator: The current context type '#arguments.className#' is 
				not currently being managed by the context and therefore cannot be instantiated by the centralized object factory.");
		}
				
		// get the class instance from the context - we need to pull out properties later on	
		var classObject = variables.context.getClass(arguments.className);
		
		// can't deal with interfaces
		if (classObject.getType() == "interface")
			return arguments.object;
													
		// iterate through each property and inject a possible dependency
		var properties = classObject.getAllProperties();
		for (var i = 1; i <= arrayLen(properties); i++) {
		
			// grab the individual property
			var property = properties[i];
			
			
			// look for the exempt property declaration - in which case we need to skip trying to inject that property
			if (structKeyExists(property, variables.annotationMarkers.exemptMarker))
				continue;
			
			/*
			 * Both the 'name' and 'type' attributes of the property must exist in order
			 * to perform autowiring.  Also, if the 'type' value is a standard CF data
			 * type, i.e., string, boolean, uuid, etc.. then we won't attempt to wire
			 * that.
			 */
			if (!structKeyExists(property, "type") || !structKeyExists(property, "name"))
				continue;
			
			/*
			When type is an array, create an empty array for it and skip
			*/
			if(property.type == "array") {
				evaluate("arguments.object.set#property.name#(ArrayNew(1))");
				continue;
			}
			
			if (arrayContains(variables.exemptTypes, property.type))
				continue;
							
			// the @cfcommons:autowiring:implementation annotation takes precedence over 'type'
			var type = structKeyExists(property, variables.annotationMarkers.implMarker) ? 
				property[variables.annotationMarkers.implMarker] : property.type;
			
			// NOW check for 'any' as the type
			if (type == "any")
				continue;
									
			// ask the centralized object factory for an instance of the dependency
			var dependency = variables.context.getObjectInstance(type);
									
			// don't attempt to inject a null dependency
			if (isNull(dependency))
				continue;
									
			// now inject it into the parent object instance
			evaluate("arguments.object.set#property.name#(dependency)");
			
		}
		
		// inject the object factory
		if (!structKeyExists(arguments.object, "$getObjectFactory")) {
			arguments.object.$setObjectFactory = $setObjectFactoryTemplate;
			arguments.object.$getObjectFactory = $getObjectFactoryTemplate;
			// now inject
			arguments.object.$setObjectFactory(variables.context.getObjectFactory());
		}
						
		return arguments.object;
	}
	
	public void function $setObjectFactoryTemplate(required ObjectFactory factory) {
		variables.$neodymium$objectFactory = arguments.factory;
	}
	
	public any function $getObjectFactoryTemplate() {
		return variables.$neodymium$objectFactory;
	}

}