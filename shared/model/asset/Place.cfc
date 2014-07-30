/**
* @accessors true
* @persistent true
* @extends shared.model.asset.Asset
* @table Asset
* @discriminatorValue Place
*/
component {

	/**
	* @type boolean	
	*/
	property isBooked;

	public Place function init(){		
		super.init();		
		return this;
	}
	
}
