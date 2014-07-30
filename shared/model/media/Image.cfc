/**
* @accessors true
* @persistent true
* @extends shared.model.media.Media
* @table Media
* @discriminatorValue Image
*/
component {

	/**
    * @type Image
    */    
    property audio;

	public Image function init(){
		super.init();
		return this;
	}

	public any function play(){
		return true;
	}	
	
}
