interface {

	public void function setLine(required string line);
	public boolean function inScript();
	public boolean function inTags();
	public boolean function inMethod();
	public boolean function atEndOfMethod();
	public boolean function inImplementation();
	public boolean function atReturn();
	public numeric function getCurrentLineNumber();

}