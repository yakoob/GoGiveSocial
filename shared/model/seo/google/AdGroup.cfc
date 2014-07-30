/**
* @displayname Visitor Adgroup
* @extends shared.model.Object
* @persistent true
* @table AdGroup
* @accessors true
*/

component{

	/**
    * @type numeric
	* @fieldtype id
	* @column AdGroupId
	* @generator native
    */
    property id;
	
	/**
    * @type string
	* @column AdName
    */
    property name;
	
	/**
    * @type numeric	
    */
    property campaignId;
	
	/**
    * @type numeric
    */
    property googleAdwordsId;
	
	/**
    * @type numeric
    */
    property costMonthFixed;

	/**
    * @type boolean
    */
    property isActive;
    
	/**
    * @type string
    */
    property dateCreated;
	
	
	/**
	* @output false
	* @hint Constructor
	*/
	public AdGroup function init(){
		super.init();		
		return this;
	}   
	
	
	
}