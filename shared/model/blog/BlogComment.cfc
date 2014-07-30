/**
* @accessors true
* @extends shared.model.Object
* @persistent true
* @table BlogComment
*/
component {
	
	/**
	* @type numeric	
	* @persistent true
	* @fieldtype id
	* @ormtype integer
	* @generator native
	* @column id
	*/
	property id;		
	
	/**
	* @type date
	*/
	property date;
	
	/**
	* @type string
	* @length 3000	
	*/
	property body;	
	
	/**
	* @type string
	*/
	property status;
	
	/**
	* @fieldtype many-to-one
	* @cfc shared.model.person.User
	* @fkcolumn userID
	* @cascade all
	*/	
	property user;

	/**
	* @fieldtype many-to-one
	* @cfc shared.model.blog.Blog
	* @fkcolumn blogID
	* @cascade all
	*/	
	property blog;	
	
	public BlogComment function init(){		
		this.setDate(now());
		this.setStatus("active");	
		return this;
	}

	public boolean function validate(){
		if ( !val(session.user.id()) )
			this.getError().add("you must login to add a comment");
		if( !len(this.getBody()) )
			this.getError().add("a comment is required");	
		/*
		if ( DateDiff("s", now(), now()) < 50 && DateDiff("s", now(), now()) > 0 )
			this.getError().add("bad date dude...");	
		*/
		return super.validate();		
	}
	
}