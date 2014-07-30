/**
* @accessors true
* @extends shared.model.Object
* @persistent true
* @table Email
*/
component {

	/**
	* @fieldtype id
	* @generator native
	* @sqltype integer	
	* @ormtype integer	
	*/
	property id;
	
	/**
	* @type string
	*/
	property destination;

	/**
	* @type string
	*/
	property status;
			
	/**
	* @type date
	*/
	property createdate;

	/**
	* @type string	
	*/
	property from;
	
	/**
	* @type string
	*/
	property to;

	/**
	* @type string
	*/
	property subject;

	/**
	* @type string
	*/
	property header;

	/**
	* @type string
	*/
	property body;

	public Email function init(){
		return this;
	}

	public boolean function send(){

		try {
			new mail(
					type="HTML"						
				,	to=this.getTo()
				, 	from=this.getFrom()
				, 	subject=this.getSubject()
				, 	body=this.getBody()
				,	server=request.mail.server
				,	port=request.mail.port
				,	useSSL=request.mail.ssl
				,	username=request.mail.username
				,	password=request.mail.password				
				).send(); 	
			return true;			
		}		
		catch (any e) {			
			return false;
		}
	}			
		
	public any function count(required any filter) {				
		return ORMExecuteQuery("SELECT COUNT(id) FROM Email");		
	}

	public any function MessageCountNew(required any filter) {				
		return ORMExecuteQuery("SELECT COUNT(id) FROM Email where status = 'new' and destination = 'in'");		
	}
	
}


		 
