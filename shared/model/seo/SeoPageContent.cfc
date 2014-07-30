/**
* @accessors true
* @extends shared.model.Object
* @persistent true
* @table SeoPageContent
*/
component {
	
	/**
	* @fieldtype id
	* @generator native	
	*/
	property id;
	
	/**
	* @type numeric
	*/
	property seoPageId;
	
	/**
	* @type string
	*/	
	property contentType;

	/**
	* @type string
	*/	
	property content;

	/**
	* @type string
	*/	
	property status;

	public SeoPageContent function init(){
		super.init();
		return this;	
	}

}
