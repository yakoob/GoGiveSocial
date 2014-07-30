interface {

	public Config function init(xml xmlConfiguration);
	public void function addEnvironment(required Environment environment);
	public boolean function hasEnvironment(required string environmentName);
	public Environment function getEnvironment(required string environmentName);
	public Environment[] function getEnvironments();

}