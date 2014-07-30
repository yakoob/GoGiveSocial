/**
 * This interface represents a ColdFusion component or interface (.cfc) template, NOT
 * instances or implementations of the said template.  
 */
interface {

	/**
	 * Will return true if either the component attribute 'initMethod' has been
	 * declared and a matching method (by name) exists OR if a standard 'init'
	 * method has been declared on the component.
	 */
	public boolean function hasConstructor();
	
	/**
	 * Will return the actual Method representing the
	 * constructor, if one exists.  If no constructor exists
	 * than an exception of type NoSuchMethodException will
	 * be thrown.  It is recommended that a call to hasConstructor()
	 * is made prior to invoking this method.
	 */
	public Method function getConstructor();

	/**
	 * Returns a true or false depening upon whether or not
	 * this class extends another.  All CF components inheritely extend
	 * WEB-INF.cftags.component - this is NOT taken into consideration with
	 * this method.  If your class does not explicitly extend another, then
	 * this will return false.
	 */
	public boolean function isSubclass();
	
	/**
	 * If no className argument is provided, then this method
	 * will return a boolean result depending upon whether or not
	 * your class implements one or more interfaces.  
	 *
	 * If a Class argument is provided and that Class instance represents 
	 * an actual implemented interface (e.g., com.mydomain.MyInterface) either directly
	 * or indirectly (implemented interface that extends the one in question)
	 * then will return true, otherwise false.
	 */
	public boolean function isImplementing(Class class);
	
	/**
	 * Returns an array of Classes representing each interface
	 * that the component in question implelements directly.  Only relevant for
	 * Class types of "component" as interfaces cannot implement other interfaces, they
	 * can however extend multiple interfaces - that information can be obtained via
	 * getSuperClasses().
	 */
	public Class[] function getInterfaces();
	
	/**
	 * Returns the canonical class name without package
	 * prefixes.
	 */
	public string function getShortName();
	
	/**
	 * Returns the class name as provided by the 
	 * native getMetaData call.  May include class packing
	 * prefix.
	 */
	public string function getName();
	
	/**
	 * Returns the class fullname as provided by the 
	 * native getMetaData call.  Will usually include
	 * class packaging prefix.
	 */
	public string function getFullName();
	
	/** 
	 * Returns the actual system file
	 * path to the class.
	 */
	public string function getPath();
	
	/**
	 * Will return an instance of Class representing
	 * this classes superclass.  A call to isSubclass() is
	 * recommended prior to invoking this method.
	 */
	public Class function getSuperClass();
	
	/**
	 * Only relevant for Class instances representing interfaces, will
	 * return an array of Classes for each directly extended interface.
	 */
	public Class[] function getSuperClasses();
	
	/** 
	 * Will return different hierarchy information depending upon whether
	 * or not the current Class instance represents either a Component or 
	 * an Interface.
	 *
	 * Component Behavior;
	 * Returns an array of Class instances in order
	 * of class hierarchy - based off of super classes.  For instance,
	 * if the current class extends Class A, and Class A extends Class B,
	 * then this method will return an array with two elements - position 1
	 * will contain a reference to Class A, and position two will contain a
	 * reference to Class B.  If this method is then invoked on Class A, then
	 * a single element array will be returned containing Class B at the first
	 * (and only) index position.
	 *
	 * Interface Behavior;
	 * Will return an array of structures.  In order to support interface multiple inheritance
	 * behavior, each array element contains a structure with two keys; "class" which contains
	 * a reference to the ancestor interface Class instance, and "hierarchy" which contains another
	 * array of structures with similar hierarchical information.  This is a non-linear hierarchy representation.
	 */
	public array function getHierarchy();
	
	/**
	 * Returns an array containing information (as a native structure)
	 * detailing all declared class properties.  Will return information
	 * on properties declared within the immediate class only - does not
	 * return information on superclass properties.
	 */
	public array function getProperties();
	
	/**
	 * Same as the getProperties() method, but will return
	 * all class hierarchy properties as well - immediately declared
	 * properties plus all superclass properties.
	 */
	public array function getAllProperties();
		
	/**
	 * Will return true or false depending upon whether
	 * or not any <cfproperty /> or property declarations
	 * exist within the class.
	 */
	public boolean function hasProperties();
	
	/**
	 * Returns a structure containing all attributes of the component along
	 * with their associated values.  An attribute is classified as an officially
	 * documented attribute of the <cfcomponent /> tag.  ORM attributes are
	 * not considered attribute as they are not members of the component 
	 * documentation - instead they will be returned as annotated from the
	 * annotation query methods.
	 */
	public struct function getAttributes();
	
	/**
	 * Returns true or false depending upon whether or not the attribute 
	 * specified by the attributeName argument exists on the component that
	 * this Class instance represents.
	 */
	public boolean function hasAttribute(required string attributeName);
	
	/**
	 * Returns the value of the attribute declared on the component.
	 */
	public string function getAttribute(required string attributeName);
	
	/**
	 * Will return true or false depending upon whether or not
	 * any non-standard <cfcomponent /> tag attributes exist in the class
	 * declaration or in the case of a script component, whether or not
	 * the class declaration has been annotated via @{attribute} or has been
	 * provided any non-standard component attributes.
	 */
	public boolean function isAnnotated();
	
	/**
	 * Returns true or false depending upon whether or not the annotation
	 * as described by the provided <pre>name</pre> argument has been
	 * declared on the class.
	 */
	public boolean function hasAnnotation(required string name);
	
	/**
	 * Returns the value succeeding the declared class annotation as
	 * described by the <pre>name</pre> argument.
	 */
	public string function getAnnotation(required string name);
	
	/**
	 * Returns all declared class annotations in the form
	 * of a structure, with the name of the annotation as the key
	 * and its associated value as the key-value.
	 */
	public struct function getAnnotations();
	
	public boolean function hasMethod(string name, string accessModifier, string returnType);
	
	/**
	 * Will return true or false depending upon whether or
	 * not the declared class has defined any methods.
	 */
	public boolean function hasMethods();
	
	/**
	 * Returns an array of Method instances represeting
	 * each method declared on the class.  Can be provided
	 * optional filter criteria such as 'name' (method name), 
	 * 'accessModifier' and 'returnType'.  Will return only
	 * the Method instances that match all of the provided criteria.
	 * If no criteria is provided, then all Class methods will be returned.
	 */
	public Method[] function getMethods(string name, string accessModifier, string returnType);
	
	/**
	 * Returns an array of Method instances that have been
	 * properly annotated.
	 */
	public Method[] function getAnnotatedMethods();
	
	/**
	 * Similar in behavior to the getAnnotatedMethods() however
	 * accepts the name of an annotation and will filter the results
	 * based off of that argument.
	 */
	public Method[] function getMethodsAnnotatedAs(required string annotation);
	
	/**
	 * Returns either "component" or "interface" depending upon
	 * the type of construct this Class is representing.
	 */
	public string function getType();
	
	/**
	 * Returns the dot-notation path to the CFC minus
	 * it's short name.
	 */
	public string function getPackage();
	
	/**
	 * Will return a boolean result based off of whether or not
	 * the current class instance extends the class whose name
	 * is provided in the className argument regardless as to how
	 * far deep within the class hierarchy the superclass resides.
	 */
	public boolean function isExtending(required Class class);
	
	/**
	 * Returns the Class instance for the class represented by the
	 * className argument if and only if the current class either
	 * directly or indirectly extends that super class.  If it does not
	 * extend it, then an exception of type InvalidParentClass will be thrown.
	 */
	public Class function getParentClass(required string className);
	
	/**
	 * Returns a string containing the 
	 * source code for the corresponding class.
	 */
	public string function getSource();
	
	/**
	 * Returns the appropriate source parser for this
	 * specific type of CFC (script or tag based).
	 */
	public SourceParser function getSourceParser();
	
	/**
	 * Will return the string value 'TAG'
	 * or 'SCRIPT' based off the primary API construct
	 * that was used to create the Component.  Tag-based
	 * CFC's that have nested cfscript elements will return
	 * 'TAG'.
	 */
	public string function getCFMLAPIType();
	
	/**
	 * Returns an instance of the class.
	 */
	public any function getInstance();
	
}