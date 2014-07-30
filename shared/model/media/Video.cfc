/**
* @accessors true
* @persistent true
* @extends shared.model.media.Media
* @table Media
* @discriminatorValue Video
*/
component {

	/**
    * @type string
    */    
    property video;

	public Video function init(){
		super.init();
		return this;
	}

	public any function play(){
		return true;
	}
}
