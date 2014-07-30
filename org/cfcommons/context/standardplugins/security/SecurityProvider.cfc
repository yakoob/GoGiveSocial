interface {

	/**
	 * Implementations of this interface will be applied as AOP cross-cutting concerns
	 * to secured resource and as such, need to conform to the cfcommons.aop aspect
	 * contract, returning a structure representing the runtime argument collection
	 * intended for the intercepted method.
	 */
	public struct function secure();
	public boolean function login();
	public boolean function logout();
	public boolean function isLoggedIn();
	public boolean function hasKeys(required string keynameList);
	public void function addDummyUser(required DummyUser user);
	public void function setLoginURL(required string url);

}