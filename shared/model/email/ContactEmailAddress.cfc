/**
* @accessors true
* @persistent true
* @extends shared.model.email.EmailAddress
* @table EmailAddress
* @discriminatorValue Contact
*/
component {
		
	public ContactEmailAddress function init(){
		super.init();
		return this;
	}

}
