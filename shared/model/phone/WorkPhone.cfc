/**
* @accessors true
* @persistent true
* @extends shared.model.phone.Phone
* @table Phone
* @discriminatorValue Work
*/
component {
	
	/**
    * @type string
    */
    property extension;
	
	public WorkPhone function init(){
		super.init();
		return this;
	}

}
