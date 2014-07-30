/**
 * Flags a type of View that is NOT
 * a layout.
 */
interface extends="org.cfcommons.faceplait.View" {

	public string function getTitleContent();
	public string function getHeadContent();
	public string function getBodyContent();
	public boolean function hasLayoutMarker();
	public string function getLayoutName(); 

}