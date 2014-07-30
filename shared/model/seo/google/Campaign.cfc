/**
* @displayname Visitor Campaign
* @extends shared.model.Object
* @persistent true
* @table Campaign
* @accessors true
*/

component{

	/**
    * @type numeric
	* @fieldtype id
	* @column CampaignID
	* @generator native
    */
    property id;
	
	/**
    * @type string
	* @column CampaignName
    */
    property name;
	
	/**
    * @type numeric
	* @column GoogleCampaignID
    */
    property googleId;
	
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
	public Campaign function init(){
		super.init();		
		return this;
	}   

	

	
}