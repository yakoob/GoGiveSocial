/**
* @accessors true
* @extends shared.model.Object
* @persistent true
* @table InitiativeTag
*/
component {
	
	/**
	* @type numeric	
	* @persistent true
	* @fieldtype id
	* @ormtype integer
	* @generator native
	* @column initiativeTagId
	*/
	property id;		
	
	/**
	* @type string
	* @length 50	
	*/
	property tag;	

	/**
	* @fieldtype many-to-one
	* @cfc shared.model.initiative.Initiative
	* @fkcolumn initiativeId
	* @cascade all
	*/	
	property initiative;	
	
	public InitiativeTag function init(){				
		return this;
	}

	public boolean function validate(){		
		if( !len(this.getTag()) )
			this.getError().add("a tag is required");			
		return super.validate();		
	}
	
}