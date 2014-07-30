/**
* @accessors true
* @extends shared.model.Object
* @persistent true
* @table LedgerBoon
*/
component {
	
	/**
	* @fieldtype id
	* @generator native
	* @column ledgerBoonId
	*/
	property id;

	/**
	* @type shared.model.initiative.Ledger
	* @fieldtype many-to-one
	* @cfc shared.model.initiative.Ledger
	* @fkcolumn ledgerId
	* @cascade all	
	*/	
	property ledger;
	
	/**    
    * @type numeric
    * @sqltype integer
    */    
    property assetId;
	
	/**    
    * @type numeric
    * @sqltype integer
    */    
    property quantity;

	/**    
    * @type numeric
    * @sqltype integer
    */    
    property personFk;
		
	public LedgerBoon function init(){	
		super.init();	
		return this;
	}
	
	public any function boon(){
		try {
			var boon = invoke.asset().where({id=this.getAssetId()})[1];
			boon.quantity(this.getQuantity());
			return boon;
		}
		catch(any e){			
			return invoke.asset();
		}			
	}	
    	
	public any function person(){
		try {
			return invoke.person().findById(this.getPersonFk());
		}
		catch(any e){
			return invoke.person();
		}
		
	}
	
}
	