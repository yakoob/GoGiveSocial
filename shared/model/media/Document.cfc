/**
* @accessors true
* @persistent true
* @extends shared.model.media.Media
* @table Media
* @discriminatorValue Document
*/
component {

	/**
    * @type string
    */    
    property document;

	public Document function init(){
		super.init();
		return this;
	}
}
