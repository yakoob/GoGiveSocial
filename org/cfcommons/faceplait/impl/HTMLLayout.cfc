component accessors="true" extends="org.cfcommons.faceplait.impl.BasicView" implements="org.cfcommons.faceplait.Layout" {

	property string name;
	property string contents;

	public HTMLLayout function init(string filePath, struct pageVars=structNew()) {
		if (!isNull(arguments.filePath))
			parseContents(arguments.filePath, arguments.pageVars);
		return this;
	}
		
	public boolean function hasLayoutMarker() {
		return refindNoCase("\<plait\:use\s+layout", getContents(), 1, false) ? true : false;
	}

	public void function replaceTitleMarker(required string content) {
		var contents = rereplaceNoCase(getContents(), "\<\s?plait\:title\s?\/?\s?\>", arguments.content);
		setContents(contents);
	}
	
	public void function replaceHeadMarker(required string content) {
		var contents = rereplaceNoCase(getContents(), "\<\s?plait\:head\s?\/?\s?\>", arguments.content);
		setContents(contents);
	}
	
	public void function replaceBodyMarker(required string content) {
		var contents = rereplaceNoCase(getContents(), "\<\s?plait\:body\s?\/?\s?\>", arguments.content);
		setContents(contents);
	}

}