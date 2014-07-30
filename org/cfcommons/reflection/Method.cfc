interface {

	/**
	 * Returns an instance of Class representing
	 * the class within which this method was declared.
	 */
	public Class function getParentClass();
	
	/**
	 * Returns the name of the method.
	 */
	public String function getName();
	
	/**
	 * Returns the name of the declared return type
	 * of the method.
	 */
	public String function getReturnType();
	
	/**
	 * Returns the type of access modified used to 
	 * declare the method (e.g., public, private, package, remote)
	 */
	public String function getAccess();
	
	/**
	 * Returns an array representing each method argument with it's associated
	 * signature information.  Argument signature information is represented
	 * as a structure.
	 */
	public array function getParameters();
	
	public struct function getAttributes();
	public boolean function hasAttribute(required string name);
	public string function getAttribute(required string name);
	
	/**
	 * Will return true or false depending upon whether or not
	 * any non-standard <cffunction /> tag attributes exist in the function
	 * declaration or in the case of a script function, whether or not
	 * the declaration has been annotated via @{attribute} in comments.
	 */
	public boolean function isAnnotated();
	
	/**
	 * Will return a structure representing each declared method
	 * annotation along with its associated value.  In the cases
	 * where a value is not present in the declaration, a "YES" string
	 * will be returned.
	 */
	public struct function getAnnotations();
	
	/**
	 * Will return true or false depending upon whether or not
	 * an annotation with the provided <pre>name</pre> argument
	 * exists on the declared method.
	 */
	public boolean function hasAnnotation(required string name);
	
	/**
	 * Will return the value as a string for the declared method
	 * annotation with the provided <pre>name</pre> argument.
	 */
	public string function getAnnotation(required string name);
	
	/**
	 * Returns a string containing the 
	 * source code only for this specific method.
	 */
	public string function getSource();
	
	/**
	 * Will return true if the current method instance is
	 * an implementation of an interface contract.  Only relevant
	 * for Methods belonging to Classes of type 'component'.
	 */
	public boolean function isImplementation();
	
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
	public Method function getInterfaceContract();
	
}