/**
* @accessors true
* @persistent true
* @extends shared.model.blog.Blog
* @table Blog
* @discriminatorValue Ledger
*/
component {

	/**
	* @type shared.model.initiative.Ledger
	* @fieldtype many-to-one
	* @cfc shared.model.initiative.Ledger
	* @fkcolumn ledgerId
	* @cascade all
	*/
	property ledger;
	
	public LedgerBlog function init(){
		this.setDate(dateformat(now(),"full"));				
		return this;
	}

	public boolean function validate(){
		if( !val(this.getinitiativeId()) )
			this.getError().add("ledger blog error");		
		return super.validate();		
	}	
	
}
