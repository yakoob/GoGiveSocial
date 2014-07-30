interface {

	public void function addRoot(required string root);
	public struct function getClasses();
	public void function addClass(required Class class);
	public boolean function hasClass(required string classpath);
	public Class function getClass(required string classpath);
	public void function purgeClass(required string classpath);
	public Class[] function getDependencies(required string classpath);
	public void function reloadClass(required string classpath);
	public Class[] function getSubclasses(required Class class);
	public Class[] function getImplementations(required Class class);

}