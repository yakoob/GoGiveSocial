component {

	public DirectoryReader function init() {
		return this;
	}
	
 	public array function getContents(required string path) {
		return directoryList(arguments.path, true, "path");
	} 

}