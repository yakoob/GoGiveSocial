/**
* @accessors true
* @extends shared.model.Object
* @persistent true
* @table InitiativeOrder
*/
component {
	
	/**
	* @fieldtype id
	* @generator native
	* @column initiativeOrderId
	*/
	property id;
	
	/**    
    * @type numeric
    * @sqltype integer
    */    
    property quantity;

	/**
	* @type shared.model.initiative.Initiative
	* @fieldtype many-to-one
	* @cfc shared.model.initiative.Initiative
	* @fkcolumn initiativeId
	* @cascade all	
	*/	
	property initiative;
	
	/**
	* @type numeric
	* @update false
	* @insert false
	*/
	property initiativeId;	
	
	/**
	* @type shared.model.asset.Asset
	* @fieldtype many-to-one
	* @cfc shared.model.asset.Asset
	* @fkcolumn initiativeAssetId
	* @cascade all	
	*/	
	property asset;	
	
	/**
	* @type shared.model.person.User
	* @fieldtype many-to-one
	* @cfc shared.model.person.User
	* @fkcolumn userId
	* @cascade all	
	*/	
	property user;		
	
	/**
	* @type numeric
	* @update false
	* @insert false
	*/
	property userId;

	public InitiativeOrder function init(){	
		super.init();	
		return this;
	}
	
}
	