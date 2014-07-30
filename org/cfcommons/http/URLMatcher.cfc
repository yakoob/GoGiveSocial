interface {

	public void function setTemplate(required String template);
	public boolean function matchesUri(required String uri);
	public struct function getPathVariables(required String uri);
	
}