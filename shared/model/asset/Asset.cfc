/**
* @accessors true
* @extends shared.model.Object
* @persistent true
* @table Asset
* @discriminatorColumn asset_type
*/
component {
	
	/**
	* @type numeric
	* @fieldtype id
	* @generator native
	* @column assetId
	*/
	property id;
		
	/**
	* @type string
	*/
	property name;
	
	/**
	* @type numeric	
	*/
	property cost;
	
	/**
	* @type numeric
	*/
	property quantity;
	
	/**
	* @type string
	*/
	property targetDate;
	
	public Asset function init(){		
		super.init();
		return this;
	}

	public boolean function validate(){
		return true;
	}
	
	public numeric function totalCost(){
		try {
			return this.getCost() * this.getQuantity();
		}
		catch(any e){
			return 0;
		}	
	}

}
