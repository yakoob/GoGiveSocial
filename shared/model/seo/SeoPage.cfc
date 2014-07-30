/**
* @accessors true
* @extends shared.model.Object
* @persistent true
* @table SeoPage
*/
component {
	
	/**
	* @fieldtype id
	* @generator native	
	*/
	property id;
	
	/**
	* @type string
	*/	
	property page;

	/**
	* @type string
	*/	
	property title;

	/**
	* @type string
	*/	
	property description;

	/**
	* @type string
	*/	
	property keywords;
	
	public SeoPage function init(){
		super.init();
		return this;	
	}

}
