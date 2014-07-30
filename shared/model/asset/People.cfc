/**
* @accessors true
* @persistent true
* @extends shared.model.asset.Asset
* @table Asset
* @discriminatorValue People
*/
component {

	/**
	* @type boolean	
	*/
	property isVolunteer;
	
	public People function init(){		
		super.init();		
		return this;
	}

}
