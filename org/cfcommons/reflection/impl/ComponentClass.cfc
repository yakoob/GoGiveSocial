import org.cfcommons.reflection.*;
import org.cfcommons.reflection.internal.*;
import org.cfcommons.reflection.internal.impl.*;

component implements="org.cfcommons.reflection.Class, org.cfcommons.reflection.metrics.MetricsCalculable" accessors="true" {

	property string name;
	property string fullname;
	property string path;
	property boolean isSubClass;
	property boolean isImplementing;
	property Class superclass;
	
	/**
	 * Only relevant when working with interfaces - this properties associated getter will return
	 * an array of Class instances representing each extended superclass - as interfaces can extend
	 * more than one other interface.  If the associated getter is invoked when Class represents
	 * a component, an empty array will be returned.
	 */
	property Class[] superClasses;
	
	property Class[] interfaces;
	property Method[] methods;
	property array properties;
	property array allProperties;
	property struct annotations;
	
	/**
	 * Constructor that accepts one of three possible arguments; 
	 * 1. A fully-qualified system path representing the location of the .cfc
	 * 2. An actual object instance.
	 * 3. The dot-notation class name.
	 * All three arguments are mutually exclusive - only one must be provided in order
	 * to create an instance of this component.
	 */
	public ComponentClass function init(string resolvedPath, any object, string class) {
		
		// basic initialization
		variables.type = "";
		variables.name = "";
		variables.fullname = "";
		variables.path = "";
		variables.isSubclass = false;
		variables.isImplementing = false;
		variables.hasConstructor = false;
		variables.constructorName = "";
		variables.methods = [];
		variables.properties = [];
		variables.allProperties = [];
		variables.superClasses = [];
		variables.interfaces = [];
		variables.attributes = {};
		variables.annotations = {};
						
		var metaData = {};
	
		if (!isNull(arguments.object) && isObject(arguments.object)) {
			var metaData = getMetadata(arguments.object);
		} else if (!isNull(arguments.class) && len(trim(arguments.class))) {
			var metaData = getComponentMetaData(arguments.class);
		// resolved path is a fully qualified system path
		} else if (!isNull(arguments.resolvedPath) && len(trim(arguments.resolvedPath))) {
			try {
				
				var metaData = getComponentMetadata(getDotNotationClassPath(arguments.resolvedPath));	
			}
			catch(any e){
				
				writedump(e);
				writedump(arguments);
				abort;
			}
			
		// component path is the dot-notation class name, i.e., org.cfcommons.reflection.impl.ComponentClass
		} else {
			throw(type="InvalidConstructorException", message="Unable to determine how to create this instance of ComponentClass.");
		}
								
		// now parse out the meta data
		parseMetaData(metaData);
		
		return this;
	}
	
	private void function parseMetaData(required struct metaData) {
	
		if (!isNull(arguments.metaData.type))
			variables.type = arguments.metaData.type;
	
		if (!isNull(arguments.metaData.fullname))
			variables.fullname = arguments.metaData.fullname;
			
		if (!isNull(arguments.metaData.name))
			variables.name = arguments.metaData.name;
			
		if (!isNull(arguments.metaData.path))
			variables.path = arguments.metaData.path;
					
		// if we're working with a component - this this is the logic we use to determine extension information
		if (!isNull(arguments.metaData.extends) && structKeyExists(arguments.metaData.extends, "fullname") && 
			!findNoCase("WEB-INF.cftags.component", arguments.metadata.extends.fullname, 1)) {
			
			variables.isSubclass = true;
			// create a class representing the superclass
			variables.superclass = new ComponentClass(resolvedPath=getDotNotationClassPath(arguments.metaData.extends.path));
		}
		
		/*
		 * Interface meta-data stores "extension" information differently as an interface can
		 * extend more than one other interface.
		 */
		if (arguments.metaData.type == "interface" && !isNull(arguments.metaData.extends) && structCount(arguments.metaData.extends)) {
			variables.isSubclass = true;
			
			// iterate through the extends struct and create a superclass for each extension
			for (key in arguments.metaData.extends) {
				// only append this superclass if its not an instance of WEB-INF.cftags.interface
				if (key != "WEB-INF.cftags.interface")			
					arrayAppend(variables.superClasses, new ComponentClass(class=key));
			}
		}
		
		
		try {
			/*
			 * Component "implements" works almost exactly like an interface type "extends" behavior in 
			 * that a component can extend more than one interface.
			 */
			if (arguments.metaData.type == "component" && !isNull(arguments.metaData.implements) && structCount(arguments.metaData.implements)) {
				variables.isImplementing = true;
				
				// iterate through the extends struct and create a superclass for each extension
				for (key in arguments.metaData.implements) {
					arrayAppend(variables.interfaces, new ComponentClass(class=key));
				}
			}
			
		}
		catch(any e){
			writedump(arguments);
			writedump(variables);
			writedump(e);		
			abort;
		}
		

		if (!isNull(arguments.metaData.properties))
			parseProperties(arguments.metaData.properties);
		
		// time to parse out the functions of this method
		if (!isNull(arguments.metaData.functions) && arrayLen(arguments.metaData.functions))
			parseMethods(arguments.metaData.functions);
		
		// extrapolate both annotations and attributes of the class	
		parseAttributes$Annotations(arguments.metaData);
				
	}
	
	private void function parseProperties(required array properties) {
		// first set immediate properties - ones declared solely on the immediate class
		variables.properties = arguments.properties;
		
		// now gather all properties from superclasses
		if (variables.type == "interface")
			return;
			
		var hierarchy = getHierarchy();
		for (var i = 1; i <= arrayLen(hierarchy); i++) {
			// ask for the properties of the current superclass
			var class = hierarchy[i];
			var classProps = class.getProperties();
			for (c = 1; c <= arrayLen(classProps); c++) {
				var prop = classProps[c];
				arrayAppend(variables.allProperties, prop);
			}
		}
		
		// now add the current class properties
		for (var i = 1; i <= arrayLen(variables.properties); i++) {
			var prop = variables.properties[i];
			arrayAppend(variables.allProperties, prop);
		}
	}
	
	/**
	 * This method accepts a structure produced by either a call to getComponentMetaData
	 * or getMetaData and extrapolates any user-defined attributes or annotations that have
	 * been provided at the component level.  It does this by separating out all annotations or
	 * attributes that are available as a part of the CF API.  Any user-defined attributes of 
	 * the <cfcomponent /> tag or custom annotations will be added either to the annotations
	 * or attributes structure. 
	 */
	private void function parseAttributes$Annotations(required struct metaData) {
	
		/*
		 * This variable as an array contains the name of every attribute
		 * that is available to the <cfcomponent /> tag as a part of the
		 * native CF API AND structural information made available whenever a call
		 * to either getMetaData or getComponentMetaData is made for a specific component.
		 * Identifying this list ensures that we can separate out annotations (user-defined
		 * attributes) as we need them.
		 */
		var nativeAttributes = ["name","fullname","path","properties","type","implements","accessors","alias",
			"functions","bindingname","displayname","extends","hint","implements","namespace","output","portypename",
			"serializable","serviceaddress","serviceportname","style","wsdlfile","batchsize","cachename","cacheuse",
			"catalog","datasource","discriminatorcolumn","discriminatorvalue","dynamicinsert","dynamicupdate","embedded",
			"entityname","hint","initmethod","joincolumn","lazy","mappedsuperclass","namespace","optimistic","output","persistent",
			"porttypename","readonly","rowid","savemapping","schema","selectbeforeupdate","serializable","serviceaddress",
			"serviceportname","style","table"];
		
		var metaAttribues = ["name","fullname","path","properties","type","functions"];
		
		for (attr in arguments.metaData) {
			if (!arrayFindNoCase(nativeAttributes, attr)) {
				structInsert(variables.annotations, attr, arguments.metaData[attr]);
			} else if (!arrayFindNoCase(metaAttribues, attr)){
				structInsert(variables.attributes, attr, arguments.metaData[attr]);
			}
		}

	}
	
	private void function parseMethods(required array methods) {
	
		for (var i = 1; i <= arrayLen(methods); i++) {
			var data = methods[i];
			arrayAppend(variables.methods, new ComponentMethod(metaData=data, parentClass=this));
		}
	
	}
	
	/**
	 * Will return true if either the component attribute 'initMethod' has been
	 * declared and a matching method (by name) exists OR if a standard 'init'
	 * method has been declared on the component.
	 */
	public boolean function hasConstructor() {
	
		// interfaces don't have an implementation - therefore can never have a constructor
		if (getType() == "interface")
			return false;
			
		/*
		 * The CFC cannot be compiled if the 'initMethod' attribute
		 * exists - therefore a constructor of the same name must exist.
		 */
		if (hasAttribute(attributeName="initMethod"))
			return true;
		else if (hasMethod(name="init"))
			return true;
			
		return false;
	}
	
	 /**
	 * Will return the actual Method representing the
	 * constructor, if one exists.  If no constructor exists
	 * than an exception of type NoSuchMethodException will
	 * be thrown.  It is recommended that a call to hasConstructor()
	 * is made prior to invoking this method.
	 */
	public Method function getConstructor() {
		if (hasAttribute(attributeName="initMethod"))
			return getMethod(name=getAttribute("initMethod"));
		else if (hasMethod(name="init"))
			return getMethod(name="init");
			
		throw(type="NoSuchMethodException", message="A method designated as an object
			constructor does not exist.");
	}
		
	private Method function getMethod(required string name) {
		var methods = getMethods();
		for (var i = 1; i <= arrayLen(methods); i++) {
			var method = methods[i];
			if (method.getName() == arguments.name)
				return method;
		}
		throw(type="NoSuchMethodException", message="A method by the name '#arguments.name#'
			does not exist.");
	}
	
	public Method[] function getMethods(string name, string accessModifier, string returnType) {
	
		if (isNull(arguments.name) && isNull(arguments.accessModifier) && isNull(arguments.returnType))
			return variables.methods;
		
		var methods = [];
			
		for (var i = 1; i <= arrayLen(variables.methods); i++) {
		
			var method = variables.methods[i];
			
			if (!isNull(arguments.name) && method.getName() != arguments.name)
				continue;
				
			if (!isNull(arguments.accessModifier) && method.getAccess() != arguments.accessModifier)
				continue;
				
			if (!isNull(arguments.returnType) && method.getReturnType() != arguments.returnType)
				continue;
			
			// otherwise, it's a match
			arrayAppend(methods, method);
		}
	
		return methods;
	}
	
	public boolean function hasMethod(string name, string accessModifier, string returnType) {
				
		if (isNull(arguments.name) && isNull(arguments.accessModifier) && isNull(arguments.returnType))
			return false;
								
		for (var i = 1; i <= arrayLen(variables.methods); i++) {
		
			var method = variables.methods[i];
			
			if (!isNull(arguments.name) && method.getName() != arguments.name)
				continue;
			else if (!isNull(arguments.accessModifier) && method.getAccess() != arguments.accessModifier)
				continue;
			else if (!isNull(arguments.returnType) && method.getReturnType() != arguments.returnType)
				continue;
			else
				return true;
			
		}
	
		return false;
	}
	
	public boolean function isSubclass() {
		return variables.isSubclass;
	}
	
	public boolean function isImplementing(Class class) {
	
		if (isNull(arguments.class))
			return variables.isImplementing;
		
		// interfaces can't implement interfaces - they can extend them
		if (getType() == "interface") {
			return false;
		}
			
		// get all of the directly implemented interfaces
		var interfaces = getInterfaces();
		for (var i = 1; i <= arrayLen(interfaces); i++) {
			var ifce = variables.interfaces[i];
			
			// is this directly implemented interface the one we're looking for?
			if (ifce.getFullName() == trim(arguments.class.getFullName())) {
				return true;
			} else if (ifce.isExtending(arguments.class)) {
				return true;
			}
			
		}
				
		return false;
	}
	
	public boolean function isAnnotated() {
		return structCount(variables.annotations) ? true : false;
	}
	
	/**
	 * Returns an array of Methods that contain non-standard 
	 * <cffunction /> attribute declarations.
	 */
	public Method[] function getAnnotatedMethods() {
	
		if (!isNull(variables.annotatedMethods))
			return variables.annotatedMethods;
	
		variables.annotatedMethods = [];
	
		var i = 1;
		for (; i <= arrayLen(variables.methods); i++) {
			var method = variables.methods[i];
			if (method.isAnnotated())
				arrayAppend(variables.annotatedMethods, method);
		}
	
		return variables.annotatedMethods;
	}
	
	/**
	 * Returns an array of Methods that contain a a non-standard
	 * <cffunction /> attribute declaration as specified by the 'annotation'
	 * argument.
	 */
	public Method[] function getMethodsAnnotatedAs(required string annotation) {
		var annotatedMethods = getAnnotatedMethods();
		var results = [];
		var i = 1;
		for (; i <= arrayLen(annotatedMethods); i++) {
			var method = annotatedMethods[i];
			if (method.isAnnotated() && method.hasAnnotation(name=arguments.annotation))
				arrayAppend(results, method);
		}
		
		return results;
	}
	
	public boolean function hasMethods() {
		return arrayLen(variables.methods) ? true : false;
	}
	
	public boolean function hasProperties() {
		return arrayLen(variables.properties) ? true : false;	
	}
	
	public struct function getAttributes() {
		return variables.attributes;
	}
	
	public boolean function hasAttribute(required string attributeName) {
		return structKeyExists(variables.attributes, arguments.attributeName);
	}
		
	public string function getAttribute(required string attributeName) {
		return variables.attributes[arguments.attributeName];
	}
	
	public boolean function hasAnnotation(required string name) {
		return structKeyExists(variables.annotations, arguments.name) ? true : false;
	}
	
	public string function getAnnotation(required string name) {
		return variables.annotations[arguments.name];
	}
	
	public string function getShortName() {
		return listLast(getName(), ".");
	}
	
	public any function getInstance() {
		return createObject("component", getFullName());
	}
	
	public string function getType() {
		return variables.type;
	}
	
	/**
	 * Returns a string containing the 
	 * source code for the corresponding class.
	 */
	public string function getSource() {
		
		// make sure to only do this once during the life of the object
		if (isNull(variables.source))
			variables.source = fileRead(getPath());
			
		return variables.source;
	}
	
	/**
	 * Will return either an array of Classes or an
	 * array of structures depending upon whether or not
	 * the current Class instance represents a component
	 * or interface.  
	 *
	 * As a potentially expensive operation, 
	 * this information is calculated once during the life 
	 * of the Class instance.
	 */
	public array function getHierarchy() {
	
		if (!isNull(variables.hierarchy))
			return variables.hierarchy;
	
		if (getType() == "component")
			variables.hierarchy = buildComponentHierarchy(this);
		else
			variables.hierarchy = buildInterfaceHierarchy(this);
			
		return variables.hierarchy;
	}
	
	/** 
	 * Component hierarchy, based off of sub and superclass hierarchy,
	 * is linear and returns an array of Classes, with the most immediate
	 * ancestor in the first position of the resulting array.
	 */
	private ComponentClass[] function buildComponentHierarchy(required ComponentClass class) {
		var hierarchy = [];
		
		// will return null if the current instance is of type "interface"
		var superclass = arguments.class.getSuperClass();
		
		// recursively move up the class hierarchy chain
		while (!isNull(superclass)) {
			arrayAppend(hierarchy, superclass);
			var superclass = superclass.getSuperClass();
		}
		
		return hierarchy;
	}
	
	/**
	 * Interface hierarchy is much different from component hierarchy in
	 * that interfaces support multiple inheritance, then can extend more
	 * than one other interface.  This call builds an array of structures.
	 * for each instance of class that represents an ancestor interface,
	 * a structure is produced with a "class" and "hierarchy" key.  The
	 * "class" key contains a reference to the interface class, and the 
	 * "hierarchy" key will contain an array representing each and every
	 * interface that the current interface extends.
	 */
	private array function buildInterfaceHierarchy(required ComponentClass class) {
		var hierarchy = [];
	
		var superclasses = arguments.class.getSuperClasses();
		
		for (var i = 1; i <= arrayLen(superclasses); i++) {
			var superclass = superclasses[i];
			var multi = {
				class = superclass,
				hierarchy = buildInterfaceHierarchy(superclass)
			};
			arrayAppend(hierarchy, multi);
		}
		
		return hierarchy;
	}
	
	/**
	 * Method now accounts for CFC's located in directories with CF mappings.
	 * Patch provided by Steve Erat.
	 */
	private string function getDotNotationClassPath(required string absolutePath) {
	
            var root = expandPath("/");
            var factory = "";
            var runtime = "";
            var mappingPrefix = "";
            var bRootMatched = true;
            var bMappingMatched = false;
                 
            // check to see if the system root path exists within the absolute path
            if (!findNoCase(root, arguments.absolutePath)){
                  bRootMatched = false;
                  // root path not matched, so iterate over CF mappings to attempt to match cfc file path to a mapping path
                  factory = createObject("java","coldfusion.server.ServiceFactory");
                  runtime = factory.getRuntimeService();
                  for (key in runtime.mappings){
                        if (findNoCase(runtime.mappings[key], arguments.absolutePath)){
                              root = runtime.mappings[key];
                              // mappingPrefix used as the first node in the dot path.
                              // e.g. /mxunit might map to C:\mxunit2.0.2 so use just "mxunit" in dot notation not "mxunit2.0.2"
                              mappingPrefix = listlast(key,"/");
                              bMappingMatched = true;
                              break;
                        }
                  }
            }
           
            // short circuit: if cannot match absolutePath to a root path or to CF mapping,
            // then give up and return the orignal absolute path
            if (!bRootMatched && !bMappingMatched)
                  return arguments.absolutePath;
                 
            var path = replaceNoCase(arguments.absolutePath, root, "", "one");
            path = mappingPrefix & path;
            path = replace(path, ".cfc", "", "one");
            // handle Windows and Unix paths
            path = replace(path, "\", ".", "all");
            path = replace(path, "/", ".", "all");
           
            // success: Resolved the absolutePath to a dot notation class path
            return path;
      } 
	
	/**
	 * Returns the dot-notation path to the CFC minus
	 * it's short name.
	 */
	public string function getPackage() {
		var name = getFullName();
		var package = listDeleteAt(name, listLen(name, "."), ".");
		return package;
	}
	
	/**
	 * Will return a boolean result based off of whether or not
	 * the current class instance extends the class whose name
	 * is provided in the className argument regardless as to how
	 * far deep within the class hierarchy the superclass resides.
	 */
	public boolean function isExtending(required Class class) {
				
		try {
			getParentClass(className=arguments.class.getFullName());
		} catch (InvalidParentClass e) {
			return false;
		}
								
		return true;				
	}
	
	/**
	 * Returns the Class instance for the class represented by the
	 * className argument if and only if the current class either
	 * directly or indirectly extends that super class.  If it does not
	 * extend it, then an exception of type InvalidParentClass will be thrown.
	 */
	public Class function getParentClass(required string className) {
	
		if (getType() == "component")
			var class = getComponentSuperclass(className=arguments.className);
		else
			var class = getInterfaceSuperclass(className=arguments.className);

		if (isNull(class)) {
			throw(type="InvalidParentClass", message="This Class instance does not
				extend the cfc '#arguments.className#'");
		}
			
		return class;
	}
	
	private Class function getComponentSuperclass(required string className) {
	
		var hierarchy = getHierarchy();
	
		for (var i = 1; i <= arrayLen(hierarchy); i++) {
			var node = hierarchy[i];
			if (node.getFullName() == arguments.className)
				return node;
		}
			
		throw(type="InvalidParentClass", message="This Class instance does not
			extend the cfc '#arguments.className#'");
	}
	
	private any function getInterfaceSuperclass(required string className) {
	
		var hierarchy = getHierarchy();
		
		for (var i = 1; i <= arrayLen(hierarchy); i++) {
			var node = hierarchy[i];
			var class = getExtendedInterface(interfaceName=arguments.className,
				interfaceHierarchy=local.node);
				
			if (!isNull(class))
				return class;
		}
		
		return;
	}
	
	private any function getExtendedInterface(required string interfaceName, 
		required struct interfaceHierarchy) {
		
		var class = arguments.interfaceHierarchy.class;
		var hierarchy = arguments.interfaceHierarchy.hierarchy;
		
		// check to see if the class matches
		if (class.getFullName() == arguments.interfaceName)
			return class;
							
		for (var i = 1; i <= arrayLen(hierarchy); i++) {
			var instance = getExtendedInterface(interfaceName=arguments.interfaceName,
					interfaceHierarchy=hierarchy[i]);
					
			if (!isNull(instance))
				return instance;
		}
		
		return;
	}
	
	/**
	 * Returns the appropriate source parser for this
	 * specific type of CFC (script or tag based).
	 */
	public SourceParser function getSourceParser() {
		if (getCFMLAPIType() == "TAG")
			return new TagSourceParser();
		else
			return new ScriptSourceParser();
	}
	
	/**
	 * Will return the string value 'TAG'
	 * or 'SCRIPT' based off the primary API construct
	 * that was used to create the Component.  Tag-based
	 * CFC's that have nested cfscript elements will return
	 * 'TAG'.
	 */
	public string function getCFMLAPIType() {
		
		if (isNull(variables.source))
			variables.source = getSource();
		
		var results = refindNoCase("\<\s*cfcomponent", variables.source, 1, true);
		if (local.results.pos[1]) {
			return "TAG";
		} else {
			return "SCRIPT";
		}
		
	}
	
	/**
	 * Runs a simple conversion algorithm on annotation or tag values
	 * that have been written in structure short-hand, and converts those
	 * string values to an actual coldfusion structure.
	 *
	 * Example;
	 * @myattribute {hello="world", 'mynameis'=slimshady}
	 *
	 * This method is not used anywhere in the implementation of ComponentClass but
	 * is provided as a convenience to any consumer that may want to utilize
	 * this method to convert annotation string values into structures.
	 */
	public struct function convertShorthandToStruct(required string shorthand) {
	
		var string = rereplace(arguments.shorthand, "[{}'""]", "", "all");
				
		var results = {};
		for (var i = 1; local.i <= listLen(local.string); local.i++) {
			var record = trim(listGetAt(local.string, local.i));
			var firstValue = trim(listGetAt(local.record, 1, "="));
			var secondValue = trim(listGetAt(local.record, 2, "="));
			local.results[firstValue] = secondValue;
		}
				
		return local.results;
	}
	
	/**
	 * Returns the associated metrics calculator. This calculator is able to run calculate code complexity.
	 */
	public MetricsCalculator function getMetricsCalculator(){
		// TODO : implementation
	}	

}