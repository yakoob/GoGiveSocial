/**
* @accessors true
* @persistent true
* @extends shared.model.blog.Blog
* @table Blog
* @discriminatorValue Initiative
*/
component {

	/**
	* @type shared.model.initiative.Initiative
	* @fieldtype many-to-one	
	* @cfc shared.model.initiative.Initiative
	* @fkcolumn initiativeId
	* @cascade all
	*/
	property initiative;	
	
	public InitiativeBlog function init(){
		this.setDate(dateformat(now(),"full"));				
		super.init();
		return this;
	}

	public boolean function validate(){
		if( !val(this.getinitiative().id()) )
			this.getError().add("initiative blog error");		
		return super.validate();		
	}	
	
}
