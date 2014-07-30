/**
* @accessors true
* @persistent true
* @extends shared.model.media.Media
* @table Media
* @discriminatorValue Pdf
*/
component {

	/**
    * @type string
    */    
    property pdf;

	public Pdf function init(){
		super.init();
		return this;
	}
}
