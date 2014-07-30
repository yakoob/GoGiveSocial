import org.cfcommons.context.*;
import org.cfcommons.reflection.*;
import org.cfcommons.reflection.impl.*;
import org.cfcommons.context.impl.*;

component accessors="true" implements="org.cfcommons.context.Reflective" {

	/**
	 * Optionally accepts a "root" argument which will construct the internal
	 * reflective Class structure.  If no root
	 * argument is passed into this constructor, then you must provide one or 
	 * more root elements after instantiation via the addRoot() method.
	 */
	public ReflectiveContext function init(string root) {
	
		variables.classes = {};
		variables.versions = {};
		variables.version = "";
		variables.roots = [];
				
		if (!isNull(arguments.root))
			addRoot(arguments.root);
					
		return this;
	}

	/**
	 * Registers a concrete instance of org.cfcommons.reflection.Class 
	 * with the Context.  If a class by the same name has already
	 * been registered with the Context, then an exception of type
	 * DuplicateClassException will be thrown.
	 */
	public void function addClass(required Class class) {
	
		// does this class already exist?
		var name = arguments.class.getFullName();
		if (structKeyExists(variables.classes, name)) {
			throw(type="DuplicateClassException", message="The Class '#name#'
				has already been registered with this Context.");
		}
	
		structInsert(variables.classes, name, arguments.class);
	}
	
	/**
	 * Will a boolean result depicting whether or not the class in question
	 * exists within the current Context. The 'classpath'
	 * argument should represent the full Class name (full dot-notation path
	 * to the CFC).
	 */
	public boolean function hasClass(required string classpath) {
	
		try {
			this.getClass(classpath=arguments.classpath);
		} catch (NoSuchClassException e) {
			return false;
		}
	
		return true;
	}
	
	/**
	 * Will return the specific Class instance that represents
	 * the CFC as provided by the 'classpath' argument.  The 'classpath'
	 * argument should represent the full Class name (full dot-notation path
	 * to the CFC).
	 *
	 * If no such Class exists (registered with the Context) then an
	 * exception of type NoSuchClassException will be thrown.  It is recommended
	 * that a call be made to hasClass() prior to invoking this method.
	 */
	public Class function getClass(required string classpath) {
	
		if (!structKeyExists(variables.classes, arguments.classpath)) {
			throw(type="NoSuchClassException", message="Class '#arguments.classpath#' has not been registered with this Context.");
		}
			
		return variables.classes[arguments.classpath];
	}
	
	/**
	 * Removes a Class and all of it's dependencies from the current Context.  The 
	 * 'classpath' argument must be the value of the getFullName() method of class in question
	 * (full dot-notation class name).  All Class dependencies will also
	 * be removed from the context (Classes that extend the primary Class) as
	 * well as their dependencies and so forth.  If the Class in question represents
	 * an interface, then all implementations of that interface will also be removed.
	 *
	 * If no such Class exists within the current context, then an exception
	 * of type NoSuchClassException will be thrown.
	 */
	public void function purgeClass(required string classpath) {
	
		// going to remove all dependencies as well, get those
		var dependencies = getDependencies(classpath=arguments.classpath);
				
		// remove all data from the registries
		structDelete(variables.classes, arguments.classpath);
		
		// now remove all dependencies
		for (var i = 1; i <= arrayLen(dependencies); i++) {
		
			var classname = dependencies[i].getFullName();		
			if (!structKeyExists(variables.classes, classname))
				continue;
				
			structDelete(variables.classes, classname);
			structDelete(variables.versions, classname);
		}
		
	}
	
	/**
	 * Returns a recursive Class array of subclasses and implementations of a given
	 * class.  This operation is recursive as the resulting Class array will contain
	 * dependencies of dependencies.
	 */
	public Class[] function getDependencies(required string classpath) {
	
		var class = this.getClass(classpath=arguments.classpath);
		var classes = [];
		
		// first obtain all subclasses
		try {
			var subclasses = getSubclasses(class=class);
		} catch (NoSubclassesException e) {
			var subclasses = [];
		}
		
		classes.addAll(subclasses);
		
		// now obtain the dependencies of each subclass
		for (var i = 1; i <= arrayLen(subclasses); i++) {
			classes.addAll(getDependencies(classpath=subclasses[i].getFullName()));
		}
		
		// is this class an interface representation?
		if (class.getType() != "interface")
			return classes;
			
		// if so, get all implementations of this interface
		var implementations = getImplementations(class=class);
		
		// now obtain the dependencies of each implementation
		for (var i = 1; i <= arrayLen(implementations); i++) {
			classes.addAll(getDependencies(classpath=implementations[i].getFullName()));
		}
		
		classes.addAll(implementations);
		
		return classes;
	}
	
	/**
	 * Will recreate a Class instance and all of it's dependencies and reregister that Class 
	 * (and dependencies) with this context.  
	 * The 'classpath' argument must be the value of the getFullName() method of 
	 * class in question (full dot-notation class name).  
	 * 
	 * All Class dependencies will also be reloaded (Classes that extend the primary Class) as
	 * well as their dependencies and so forth. If the Class in question represents
	 * an interface, then all implementations of that interface will also be reloaded.
	 *
	 * If no such Class exists within the current context, then an exception
	 * of type NoSuchClassException will be thrown.
	 */
	public void function reloadClass(required string classpath) {
		
		// going to remove/recreate all dependencies as well, get those
		var dependencies = getDependencies(classpath=arguments.classpath);
		
		// first, remove the primary class from the context
		// trace(type="information", text="Reloading '#arguments.classpath#' from the Context.");
		structDelete(variables.classes, arguments.classpath);
		
		// now instantiate a new Class for this one and re-register it
		var reloadedClass = new ComponentClass(class=arguments.classpath);
		addClass(reloadedClass);
		
		// now remove/recreate all dependencies
		for (var i = 1; i <= arrayLen(dependencies); i++) {
		
			var classname = dependencies[i].getFullName();		
			if (!structKeyExists(variables.classes, classname))
				continue;
				
			// trace(type="information", text="Reloading '#classname#'.");
			structDelete(variables.classes, classname);
			
			// now re-register a new ComponentClass instance
			var reloadedClass = new ComponentClass(class=classname);
			addClass(reloadedClass);
		}
		
	}
	
	/**
	 * This method both establishes the root of the context and
	 * parses the root directory recursively and creates / registers an 
	 * instance of ComponentClass for each CFC (component and interface).
	 *
	 * DEPRECATED - use addRoot() instead.
	 */
	public void function setRoot(required string root) {
		arrayAppend(variables.roots, arguments.root);
		loadFromRoot(root=arguments.root);		
	}
	
	/**
	 * May be invoked any number of times on an existing
	 * Context in order to allow the context to parse and register
	 * Class instances for .CFC's located in more than one unrelated directory.
	 *
	 * Each root is recursive, meaning subdirectories of the parent root
	 * directory will by default be introspected for CFC's and do not
	 * need to be explicitly added to this Context via addRoot().
	 */
	public void function addRoot(required string root) {
		
		if (!directoryExists(arguments.root)) {
			throw(type="InvalidSystemPathException", message="The system path '#arguments.root#'
				is not valid and cannot be used as a context root.");
		}
		
		if (!arrayContains(variables.roots, arguments.root))
			arrayAppend(variables.roots, arguments.root);
		
		loadFromRoot(root=arguments.root);
	}
	
	private void function loadFromRoot(required string root) {
	
		var contents = directoryList(arguments.root, true, "query", "*.cfc");
				
		// iterate throught the contents and create AND register an instance of ComponentClass
		for (var i = 1; i <= contents.recordcount; i++) {
		
			var record = contents.directory[i] & "\" & contents.name[i];
												
			// we only care about files ending with *.cfc
			if (listLast(record, ".") != "cfc")
				continue;
				
			var version = hash(contents.datelastmodified[i]);
			
			// register a version for this CFC
			variables.versions[record] = version;
			var class = new ComponentClass(resolvedPath=record);
			
			if (!hasClass(class.getFullName()))			
				addClass(class);
		}
		
	}
				
	/**
	 * Returns an array of Class implementations representing
	 * subclasses if the underlying component / interface 
	 * represented by the Class argument is being extended 
	 * by any other classes within the context.  If no other
	 * classes are extending the class in question, then an exception
	 * of type "NoSubclassesException" will be thrown.
	 */
	public Class[] function getSubclasses(required Class class) {
	
		var subClasses = [];
	
		for (name in variables.classes) {
			var subclass = variables.classes[name];
			if (subclass.isExtending(arguments.class))
				arrayAppend(subClasses, subclass);
		}
			
		if (!arrayLen(subClasses)) {
			throw(type="NoSubclassesException", message="There are no known
				subclasses for '#arguments.class.getFullName()#'");
		}
	
		return subClasses;
	}
		
	/**
	 * Returns an array of Class instances representing components
	 * that implement (as an interface) the provided Class that exist within
	 * the current Context.  Class types passed in as an argument that do not represent an interface
	 * (where getType() == 'component') will cause this method to throw
	 * an exception of type 'InvalidClassArgument'.
	 */
	public Class[] function getImplementations(required Class class) {
		
		if (arguments.class.getType() != 'interface') {
			throw(type="InvalidClassArgument", message="Only Class types that represent
				interfaces can return implementation information.");
		}
		
		var implementations = [];
		
		for (name in variables.classes) {
			var implementation = variables.classes[name];
			if (implementation.getType() == "component" && implementation.isImplementing(arguments.class))
				arrayAppend(implementations, implementation);
		}
		
		return implementations;
	}
	
	/**
	 * The version is a string containing a hash value generated by concatenating
	 * hash values for each directory item "datelastmodified" file value that was parsed in the context.
	 * This value will change only when the contents of the context have changed.
	 */
	public string function getVersion() {
		return variables.version;
	}
	
	public struct function getClasses() {
		return variables.classes;
	}
	
}