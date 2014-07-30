/**
* @accessors true
* @persistent true
* @extends shared.model.blog.Blog
* @table Blog
* @discriminatorValue User
*/
component {
	
	/**
	* @type string	
	*/
	property tags;
	
	public UserBlog function init(){
		this.setDate(dateformat(now(),"full"));				
		return this;
	}

	public boolean function validate(){		
		return super.validate();		
	}	
	
}
