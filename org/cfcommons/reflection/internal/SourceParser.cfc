interface {

	public boolean function inScript();
	public boolean function inTags();
	public boolean function inMethod();
	public boolean function atEndOfMethod();
	public boolean function isBeginningOfMethod();
	public boolean function inImplementation();
	public boolean function atReturn();
	public numeric function getCurrentLineNumber();
	public string function getCurrentMethodName();

}