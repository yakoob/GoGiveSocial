/**
* @accessors true
* @persistent true
* @extends shared.model.asset.Asset
* @table Asset
* @discriminatorValue Material
*/
component {
	 
	/**
	* @type boolean	
	*/
	property isDonation;
	
	public Material function init(){		
		super.init();		
		return this;
	}
	
}
