/**
* @accessors true
* @extends shared.model.Object
* @persistent true
*/
component {

	/**
	* @fieldtype id
	* @generator native
	* @column initiativeId
	*/
	property id;

	/**
	* @type date
	*/
	property date;
	
	/**
	* @type string
	*/
	property name;
	
	/**
	* @type string
	* @length 3000
	*/
	property description;
	
	/**
	* @type string
	* @length 3000
	*/
	property summary;
	
	/**
	* @type string
	* @length 3000
	*/
	property issue;
	
	/**
	* @type string
	* @length 3000
	*/
	property solution;

	/**
	* @type string
	* @length 3000
	*/
	property message;
	
	/**
	* @type string
	*/
	property status;
	
	/**
	* @type numeric
	*/
	property accountId;	
	
	/**
	* @insert false
	* @update false
	* @sqltype integer
	*/
	property userId;

	/**
	* @type shared.model.person.User
	* @fieldtype many-to-one
	* @cfc shared.model.person.User
	* @fkcolumn userId
	* @cascade all	
	*/	
	property user;
	
	/**	
	* @type shared.model.account.Account
	* @fieldtype many-to-one
	* @cfc shared.model.account.Account
	* @fkcolumn accountId
	* @update false
	* @insert false
	*/	
	property account;		
	
	/**
	* @type array
	* @fieldtype one-to-many
	* @cfc shared.model.blog.InitiativeBlog
	* @fkcolumn initiativeId
	* @cascade all	
	*/	
	property blogs;
	
	/**
	* @type shared.model.initiative.Ledger
	* @fieldtype one-to-one
	* @cfc shared.model.initiative.Ledger
	* @fkcolumn ledgerId
	* @cascade all
	*/
	property ledger; 
	
	public Initiative function init(){
		super.init();		
		return this;
	}
	
	public boolean function validate(){
		if ( !val(session.user.id()) )
			this.getError().add("you must login to add a blog");		
		if( !len(this.getDate()) )
			this.getError().add("a target date is required");		
		if( !len(this.getName()) )
			this.getError().add("a name is required");		
		if ( !len(this.getSummary()) )
			this.getError().add("a summary is required");		
		return super.validate();		
	}

	public any function getLedgerSummary(required numeric ledgerId){
		
		try {	     
		    var spService = new storedproc(); 	     
		    spService.setDatasource(request.datasource); 
		    spService.setProcedure("InitiativeContributionSummary");	       
		    spService.addParam(cfsqltype="cf_sql_numeric",type="in",value=arguments.ledgerId); 
		    spService.addProcResult(name="rs1",resultset=1); 
		    var res = spService.execute().getprocResultSets().rs1;		    	    
		    var result = {};
		    result["donationNeeded"] = res.donationNeeded[1];
		    result["donationBooked"] = res.donationBooked[1];
		    result["volunteerNeeded"] = res.volunteerNeeded[1];
		    result["volunteerBooked"] = res.volunteerBooked[1];
		   	result["percentage"] = res.percentage[1];		    
		    return result;
	    }
	    catch(any e){	  
   			var result = {};
		    result["donationNeeded"] = 0;
		    result["donationBooked"] = 0;
		    result["volunteerNeeded"] = 0;
		    result["volunteerBooked"] = 0;
		   	result["percentage"] = 2;			    	  	
	    	return result;
	    } 	
	}

}



