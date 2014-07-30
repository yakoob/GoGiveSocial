/**
* @accessors true
* @persistent true
* @extends shared.model.media.Media
* @table Media
* @discriminatorValue Audio
* @implements shared.model.media.IMedia
*/
component {

	/**
    * @type string
    */    
    property audio;
	
	public Audio function init(){
		super.init();
		return this;
	}

	public any function play(){
		return true;
	}
}
