/**
* @persistent true
* @accessors true
* @extends shared.model.Object
*/
component {
	
	/**
	* @type numeric
	* @persistent true	
	* @ormtype integer
	* @generator native
	* @column id
	*/
	property id;
	
	/**
    * @type string
	* @fieldtype id	
    */
    property iso;
	
	/**
    * @type string
    */
    property e164;
	
	/**
    * @type string
    */
    property name;
	
	/**
    * @type string
    */
    property subnationalEntityName;
    
	/**
    * @type string
    */
    property translationLanguageCode;
    
	/**
    * @type numeric
    */
    property currencyID;
    
	/**
    * @type numeric
    */
    property populationCount;
	
	/**
    * @type numeric
    */
    property fraudRiskLevel;
	
	/**
    * @type boolean
    */
    property hasFreeDemo;
	
	/**
    * @type boolean
    */
    property isActive;
    
	/**
    * @type boolean
    */
    property isDisplayedInAddress;
		
	public Country function init(){		
		return this;
	}
}
