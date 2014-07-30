/**
 * Indicates a view containing
 * faceplait-specific markup from other types of Views.
 */
interface extends="org.cfcommons.faceplait.View" {

	public void function replaceTitleMarker(required string content);
	public void function replaceHeadMarker(required string content);
	public void function replaceBodyMarker(required string content);
	public boolean function hasLayoutMarker();

}