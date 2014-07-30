/**
* @accessors true
* @extends shared.model.Object
* @persistent true
* @table WebMessage
*/
component {
	
	/**
	* @fieldtype id
	* @generator native
	* @column webMessageId
	*/
	property id;
	
	/**
	* @type string
	*/
	property uid;

	/**
	* @type numeric
	* @sqltype integer
	*/
	property to;

	/**
	* @type numeric
	* @sqltype integer
	*/
	property from;

	/**
	* @type string
	*/
	property date;
	
	/**
    * @type string
    */    
    property subject;
        
    /**
    * @type string
    */   
    property body;
	
	public WebMessage function init(){
		this.setUid(replace(createuuid(),"-","","all"));
		this.setDate(now());		
		super.init();
		
		return this;
	}
	
	public any function userFrom(){
		try {
			return invoke.user().where({id=this.getFrom()})[1];		
		}
		catch(any e){
			return invoke.user();
		}
		
	}

	public any function userTo(){
		try {
			return invoke.user().where({id=this.getTo()})[1];		
		}
		catch(any e){
			return invoke.user();
		}		
	}
	
	public boolean function validate(){
		if ( !val(session.user.id()) )
			this.getError().add("you must login to add a blog");			
		if( !len(this.getSubject()) )
			this.getError().add("a subject is required");					
		if ( !len(this.getbody()) )
			this.getError().add("a body is required");	
		return super.validate();		
	}			
		
}
