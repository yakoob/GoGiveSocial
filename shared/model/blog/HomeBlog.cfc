/**
* @accessors true
* @persistent true
* @extends shared.model.blog.Blog
* @table Blog
* @discriminatorValue Home
*/
component {
	
	/**
	* @type string
	*/
	property metaData;
		
	public HomeBlog function init(){		
		return this;
	}
}
