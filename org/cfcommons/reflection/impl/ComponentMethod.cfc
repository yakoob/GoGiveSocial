import org.cfcommons.reflection.*;

component implements="org.cfcommons.reflection.Method, org.cfcommons.reflection.metrics.MetricsCalculable" accessors="true" {

	property string name;
	property string access;
	property string returnType;
	property array parameters;
	property struct annotations;
	property struct attributes;
	property Class parentClass;
	
	public ComponentMethod function init(required struct metaData, required any parentClass) {
		
		variables.annotations = {};
		variables.attributes = {};
		
		variables.parentClass = parentClass;
		
		if (!isNull(arguments.metaData.access))
			variables.access = arguments.metaData.access;
			
		if (!isNull(arguments.metaData.name))
			variables.name = arguments.metaData.name;
			
		if (!isNull(arguments.metaData.parameters))
			variables.parameters = arguments.metaData.parameters;
			
		if (!isNull(arguments.metaData.returnType))
			variables.returnType = arguments.metaData.returnType;
			
		parseAttributes$Annotations(arguments.metaData);
	
		return this;
	}
	
	private void function parseAttributes$Annotations(required struct metaData) {
	
		/*
		 * This variable as an array contains the name of every attribute
		 * that is available to the <cffunction /> tag as a part of the
		 * native CF API AND structural information made available whenever a call
		 * to either getMetaData or getComponentMetaData is made for a specific component.
		 * Identifying this list ensures that we can separate out annotations (user-defined
		 * attributes) as we need them.
		 */
		var nativeAttributes = [
			"name",
			"access",
			"description",
			"displayname",
			"hint",
			"output",
			"returnformat",
			"returnType",
			"roles",
			"secureJson",
			"verifyClient",
			"parameters",
			"resolvedArgType"
		];
	
		var annotations = {};
		
		for (attr in arguments.metaData) {
		
			var data = arguments.metaData[attr];
								
			if (!arrayFindNoCase(nativeAttributes, attr)) {
				structInsert(variables.annotations, attr, data);
			} else {
				structInsert(variables.attributes, attr, data);
			}
		}
	}
	
	public struct function getAttributes() {
		return variables.attributes;
	}
	
	public boolean function hasAttribute(required string name) {
		return structKeyExists(variables.attributes, arguments.name) ? true : false;	
	}
	
	public string function getAttribute(required string name) {
		return variables.attributes[arguments.name];
	}
	
	public boolean function isAnnotated() {
		return structCount(variables.annotations) ? true : false;
	}
	
	public struct function getAnnotations() {
		return variables.annotations;
	}
	
	public boolean function hasAnnotation(required string name) {
		return structKeyExists(variables.annotations, arguments.name) ? true : false;	
	}
	
	public string function getAnnotation(required string name) {
		return variables.annotations[arguments.name];
	}
	
	/**
	 * Returns a string containing the 
	 * source code only for this specific method.
	 */
	public string function getSource() {
	
		// if the source has already been extracted - return it
		if (!isNull(variables.source))
			return variables.source;
	
		// the parent class has parser - ask for it
		var class = getParentClass();
		var parser = class.getSourceParser();
		
		// need to extrapolate the current method source from the component source file
		var path = class.getPath();			
		var file = createObject("java", "java.io.File").init(path);
		var scanner = createObject("java", "java.util.Scanner").init(file);
		var source = createObject("java", "java.lang.StringBuilder");
		 
		while(scanner.hasNextLine()) {
		
			var line = local.scanner.nextLine();
			local.parser.setLine(local.line);
												
			if (trim(local.parser.getCurrentMethodName()) == trim(getName())) {
				// ensure the resulting source is well-formed
				local.line = local.line & chr(10);
				local.source.append(local.line);
			}
				
		}
					
		// important
		local.scanner.close();
		
		variables.source = local.source.toString();
		
		return variables.source;
	}
	
	/**
	 * Returns the associated metrics calculator. This calculator is able to run calculate code complexity.
	 */
	public MetricsCalculator function getMetricsCalculator(){
		// TODO : implementation
	}
	
	/**
	 * Will return true if the current method instance is
	 * an implementation of an interface contract.  Only relevant
	 * for Methods belonging to Classes of type 'component'.
	 */
	public boolean function isImplementation() {
	
		try {
			getInterfaceContract();
		} catch (NoDefinedContractException e) {
			return false;
		}
		
		return true;
	}
	
	/**
	 * Will return the Method instance declared on a Class of
	 * type 'interface' from which this current method instance
	 * was contracted.  If the current Method instance is not
	 * an implementation of an interface method then an exception
	 * of type NoDefinedContractException will be thrown.  It is
	 * recommended that a call to hasContract() be made prior 
	 * to invoking this method.
	 *
	 * You can obtain a reference to the actual interface class
	 * that declares the contract method by asking for the superclass
	 * of the resulting method;
	 *
	 * getInterfaceContract().getParentClass();
	 */
	public Method function getInterfaceContract() {
	
		var class = getParentClass();
		var interfaces = class.getInterfaces();
		
		// need info about this current method instance
		var name = getName();
		var access = getAccess();
		var returntype = getReturnType();
	
		// iterate through each implemented interface to see if the method is declared within them	
		for (var i = 1; i <= arrayLen(interfaces); i++) {
			var ifce = interfaces[i];
			
			try {
				var method = findMethod(class=ifce, name=name, accessModifier=access, returntype=returntype);
			} catch (NoSuchMethodException e) {
				continue;
			}
		}
		
		if (!isNull(method))
			return method;
		
		// no contract exists for this method
		throw(type="NoDefinedContractException", message="The method #name#() declared
			in the class #getParentClass().getName()# is not an implementation of an interface method.");
		
	}
	
	/**
	 * Will recursively search through each interface parent class in order to find
	 * a method that matches the criteria specified in name, accessModifier and returntype
	 * arguments.  If no matching method is located at any level, then an exception
	 * of type NoSuchMethodException will be thrown.
	 */
	private Method function findMethod(required Class class, required string name, required string accessModifier,
		required string returnType) {
		
		if (arguments.class.getType() == "component") {
			throw("No components!  Only interfaces!");
		}
	
		// first check to see if the immediate interface declares a matching contract method
		if (arguments.class.hasMethod(name=arguments.name, accessModifier=arguments.accessModifier, 
			returnType=arguments.returntype)) {
			
			var methods = arguments.class.getMethods(name=arguments.name, accessModifier=arguments.accessModifier, 
				returntype=arguments.returntype);
				
			return methods[1];
		// is this interface extending others?
		} else if (arguments.class.isSubclass()) {
			var parentclasses = arguments.class.getSuperClasses();
			for (var i = 1; i <= arrayLen(parentclasses); i++) {
				var parent = parentClasses[i];
				var method = findMethod(class=parent, name=arguments.name, accessModifier=arguments.accessModifier,
					returntype=arguments.returntype);
				if (!isNull(method))
					return method;
			}
		}
				
		throw(type="NoSuchMethodException", message="No dice.");
	}
		
}