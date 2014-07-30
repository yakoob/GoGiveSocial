/**
* @accessors true
* @extends shared.model.Object
* @persistent true
* @table Blog
* @discriminatorColumn blog_type
*/
component {
	
	/**
	* @fieldtype id
	* @generator native
	* @column blogId
	*/
	property id;
	
	/**
	* @numeric
	*/
	property accountId;

	/**
	* @type date
	*/
	property date;
	
	/**
	* @type string
	*/
	property subject;	
	
	/**
	* @type string
	* @length 3000
	*/
	property body;	
	
	/**
	* @type string
	* @default active
	*/
	property status;
	
	/**
	* @fieldtype one-to-many
	* @cfc shared.model.blog.BlogComment
	* @fkcolumn blogID
	* @cascade all
	*/	
	property comment;
	
	/**
	* @fieldtype one-to-many
	* @cfc shared.model.blog.BlogTag
	* @fkcolumn blogID
	* @cascade all
	*/	
	property tag;

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
	* @insert false
	* @update false
	*/	
	property account;		
		
	/**
	* @update false
	* @insert false
	* @type numeric
	* @sqltype integer
	*/
	property userId;
		
	public Blog function init(){
		this.setDate(dateformat(now(),"full"));		
		return this;
	}
	
	public boolean function validate(){
		if ( !val(session.user.id()) )
			this.getError().add("you must login to add a blog");		
		if( !len(this.getBody()) )
			this.getError().add("a body is required");		
		if ( !len(this.getSubject()) )
			this.getError().add("a subject is required");	
		return super.validate();		
	}	
	
}
	