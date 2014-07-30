/**
* @accessors true
* @extends shared.model.Object
* @persistent true
* @table BlogTag
*/
component {
	
	/**
	* @type numeric	
	* @persistent true
	* @fieldtype id
	* @ormtype integer
	* @generator native
	* @column blogTagId
	*/
	property id;		
	
	/**
	* @type string
	* @length 50	
	*/
	property tag;	

	/**
	* @fieldtype many-to-one
	* @cfc shared.model.blog.Blog
	* @fkcolumn blogID
	* @cascade all
	*/	
	property blog;	
	
	public BlogTag function init(){				
		return this;
	}

	public boolean function validate(){		
		if( !len(this.getTag()) )
			this.getError().add("a tag is required");			
		return super.validate();		
	}
	
}