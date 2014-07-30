interface {

	public string function getLoginRedirect();
	public string function getLoginFormTemplatePath();
	public string function getLogoutRedirect();
	public string function getSecurityProviderClass();
	public array function getSecuredRequests();
	public DummyUser[] function getDummyUsers();

}