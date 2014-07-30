/**
* @accessors true
* @persistent true
* @extends shared.model.phone.Phone
* @table Phone
* @discriminatorValue Home
*/
component {
	
	/**
    * @type string
    */
    property timeToCall;
    
	
	public HomePhone function init(){
		return this;
	}

}
