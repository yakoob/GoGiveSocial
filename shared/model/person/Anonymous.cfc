/**
* @accessors true
* @persistent true
* @extends shared.model.person.Person
* @table Person
* @discriminatorValue anonymous
*/
component {

	/**
    * @type string
    */    
    property sudo;
	
	public Anonymous function init(){	
		super.init();
		return this;
	}
}
