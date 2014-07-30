interface {
	
	public string function getRoot();
	// should return "always", "auto", and "never"
	public string function getReloadType();
	public void function addPluginConfig(required EnvironmentPluginConfig config);
	public EnvironmentPluginConfig[] function getPluginConfigs();

}