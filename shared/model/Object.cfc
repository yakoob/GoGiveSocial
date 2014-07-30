/**
* @output false
* @accessors true
*/
component {

	/**
	* @type shared.model.Invoke
	*/
	property invoke;

	/**
	* @type string
	* @default ""	
	*/
	property objectId;	
	
	/**
	* @type string
	* @default id
	*/
	property sort;
	
	/**
	* @type string
	* @default desc
	*/
	property direction;
	
	/**
	* @type numeric
	* @default 100
	*/
	property size;

	/**
	* @type numeric
	* @default 0
	*/
	property offset;
	
	/**
    * @type struct
    */
    property criteria;
	
	/**
	* @type shared.model.error.Error
	*/
	property error;
				
	/**
	* @output false
	*/	
	null = JavaCast( 'null', 0 );
	
	public Object function init(){		
		variables.objectId = CreateUUID();		
		invoke = application.invoke;		
		return this;		
	}

	public any function where(required struct args){
		sc = "sort,direction,size,offset";		
		for (local.x = 1; x <= listlen(sc); x = x+1) {
			try {
				var propName = listGetAt( sc, x );
				_setProperty( propName, arguments.args[ propName ], true );
				structdelete( arguments.args, propName );		
			}
			catch (any e){
				// fail silently
			}
		}		
		setCriteria(arguments.args);	
		return search();
	}

	public any function like(required array keys, string searchString="") {	    
	    var str = " WHERE 1 = 0 ";		
		for (local.key in arguments.keys) {			
			str = str & " OR a." & key & " LIKE :searchString ";		 
		}				
		return OrmExecuteQuery( "
			SELECT 
				a
            FROM 
                #listlast(getMetadata(this).name,".")# a            
			#str# ",
        {searchString='%#arguments.searchString#%'} );
	}

	public any function new(){
		return EntityNew(listlast(getMetadata(this).name,".")).init();	
	}

	public any function search(){	
		var obj = [];																							
		if (val(this.getID())) 
			return EntityLoadByPK(listlast(getMetadata(this).name,"."),this.getID());		
		else 
			return entityLoad("#listlast(getMetadata(this).name,".")#", this.getCriteria(),this.getSort() & " " & this.getDirection(), {maxresults=this.getSize(),offset=this.getOffset()});		
	}
	
	public any function load(){
		var res = "";
		if (val(this.getID())) {
			res = EntityLoadByPK(listlast(getMetadata(this).name,"."),this.getID());
			if (!isnull(res))
				return res;			
		}
		return EntityNew(listlast(getMetadata(this).name,".")).init();		
	}
	
	/**
	* @output false	
	*/
	public any function save(){		
		
		if (validate()) {
			// writeDump("orm save");
			local.res = load();
			objToObj(this, res);
			entitySave(this);
			ormflush();
		}
		else {
			this.getError().add("#getMetadata(this).name# validate() is false");
		}
		return this;		
	}

	public boolean function validate(){
		return this.getError().has() ? false : true;
	}
	
	/**
	* @output false	
	*/
	public void function delete(){		
		EntityDelete(load());
		ormflush();			
	}

	/**
	* @output false
	* @hint sets ORM object properties == argument object's properties
	*/
	public any function objToObj(required any srcObj, required any targObj){				
		var propArray = new org.cfcommons.reflection.impl.ComponentClass(object=srcObj).getAllProperties();											
		for (local.y = 1; local.y <= arraylen(propArray); local.y++) {			
			local.objArgKey = propArray[y].name;
			local.objArgVal = arguments.srcObj._getProperty(propArray[y].name);			
			
			if (!isnull(OBJARGVAL))
			arguments.targObj._setProperty(local.objArgKey,local.objArgVal);					
		}	
		return arguments.targObj;
	}
	
	
	/**
	* @output true
	* @hint sets ORM object properties == argument's matching struct key pair values
	*/
	public any function structToObj(required any data, any srcObj=this){			
		var propArray = new org.cfcommons.reflection.impl.ComponentClass(object=srcObj).getAllProperties();			
		local.objArgVal = "";
		for (local.key in data) {
			if ( len(key) > 2 && right(key,2) == "ID" ) {				
				var $key = replace(key,"ID","","all");			
				evaluate("srcObj.#$key#(invoke.#$key#().findById(#data[key]#))");	
			}
			else if ( len(key) == 2 && right(key,2) == "ID" && val(data[key]) ) {				
				arguments.srcObj = arguments.srcObj.findById(data[key]);				
			}
		}					
		for (local.y = 1; local.y <= arraylen(propArray); local.y++) {			
			local.objArgKey = propArray[y].name;
			try {
				local.objArgType = propArray[y].type;
				objArgVal = arguments.data["#objArgKey#"];
				objArgVal = urldecode(objArgVal);		
				if (structkeyexists(data,objArgKey)){								
					if(IsSimpleValue( objArgType ) )
						arguments.srcObj._setProperty(objArgKey,objArgVal);
				}			
			}
			catch(any e){
				// blahh
			}
		}
		return srcObj;
	}
    
	/**
	* @output true
	* @hint alias for structToObj
	*/
	public void function update_attributes( required struct propertyStruct ){
		structToObj( arguments.propertyStruct, this );			
		this.validate();
	}

	public void function addProperty(required string key, required string value){
		variables[arguments.key]=arguments.value;
	}	

	/**
	* @output false
	*/
	public boolean function same( Object object ){
		return arguments.object.objectID() EQ this.objectId();
	}
	
	/**
	* @output false
	* @hint Override this method to provide meaningful comparison from subclasses
	*/
	public boolean function sameAs( Object object ){
		return same( arguments.object );
	}
	
	public void function dump( ){
		this.attributes = {};	
		for ( val in variables ){
			if ( issimplevalue(variables[val]) && val != 'KEY'){			
				this.attributes[ val ] = variables[ val ];
			}
		}		
		writeDump(this);	
	}

	public void function setArgs(args){				
		var className = getMetadata(this).name;				
				
		if(!structkeyexists(application.remoteProperties,className)){	
			application.remoteProperties[ className ] = {};								
			var allProperties = new org.cfcommons.reflection.impl.ComponentClass(object=this).getAllProperties();
			for (var x=1; x <= arraylen(allProperties); x=x+1) {
				if (structkeyexists(allProperties[x], 'access')) {
					if ( allProperties[x].access == "remote") {
					application.remoteProperties[ className ][allProperties[ x ].name ] = true;
					}
				}
			}
		}		
		
		// application.remoteProperties[className]
		for ( key in arguments.args ){						
			if( StructKeyExists( application.remoteProperties[ className ], key ))
				_setProperty(key,arguments.args[ key ]);			
		}			
	}	
		
	public any function onMissingMethod( missingMethodName, missingMethodArguments ){
		if ( arguments.missingMethodName == 'findById') {
			variables.criteria[ 'Id' ] = arguments.missingMethodArguments[1];
			var searchResults = search();
			if ( ArrayLen( searchResults ) ){
				return searchResults[1];
			} else{
				var md = getMetaData( this );
				return application.context.ioc.getObjectInstance(class=md.name);									
			}
		}
		
		if (left( arguments.missingMethodName, 6 ) == "findBy"){
			var strippedMethodName = Mid( arguments.missingMethodName, 7, Len( arguments.missingMethodName) );
			variables.criteria[ strippedMethodName ] = arguments.missingMethodArguments[1];
			variables.size = 100000000;
			return search();		
		}
		
		if (left( arguments.missingMethodName, 7 ) == "findOne"){
			var strippedMethodName = Mid( arguments.missingMethodName, 8, Len( arguments.missingMethodName) );
			variables.criteria[ strippedMethodName ] = arguments.missingMethodArguments[1];
			try {
				return search()[1];
			}
			catch(any e) {
				var md = getMetaData( this );
				return application.context.ioc.getObjectInstance(class=md.name);
			}
					
		}
		
		if( arrayLen( arguments.missingMethodArguments )){
			try {
				_setProperty( arguments.missingMethodName, arguments.missingMethodArguments[1] );				
			}
			catch(any e){
				// I fuckin fail
			}					
			return this;					
		} 
		else {
			return _getProperty( arguments.missingMethodName );
		}
	}	

	public any function cf_param(var_name, default_value) { 
		if(not isDefined(var_name))   
			SetVariable(var_name, default_value); 
	}
	
	/**
	* @output false
	* @hint set named property
	*/
	public void function _setProperty(required any name, any value, boolean orm=false){
		local.theMethod = this["set" & arguments.name];
		
		if (isNull(arguments.value)){
			if ( !arguments.orm )
				theMethod(javacast('NULL', ''));
		}else
			theMethod(arguments.value);
	}
		
	public any function _getProperty(required any name) {
		local.theMethod = this["get" & arguments.name];
		if (isNull(arguments.value))
			return theMethod(javacast('NULL', ''));
		else
			return theMethod(arguments.value);		
	}
	
	/**
	* @output false
	* @hint set named property null
	*/
	private void function _setPropertyNull(required any name){
		_setProperty(arguments.name);
	}
		
	/**
	* @output false
	* @hint clean input
	*/
	private any function _cleanse(required any data){
		return HTMLEditFormat(arguments.data);
	}	
	
	public struct function pubArgs(required struct args){		
		var res = args;		
		structdelete(res, "app");		
		structdelete(res, "username");
		structdelete(res, "password");
		structdelete(res, "POINTCUTNAME");
		structdelete(res, "reload");		
		structdelete(res, "protocol");
		structdelete(res, "dsn");
		structdelete(res, "datasource");					
		structdelete(res, "api");	
		structdelete(res, "facebook");
		structdelete(res, "linkedin");
		structdelete(res, "stripe");		
		structdelete(res, "mail");
		structdelete(res, "_EXTENSION");
		structdelete(res, "_CONTEXT");
		structdelete(res, "_LISTENERS");
		structdelete(res, "_CONTEXT");
		structdelete(res, "_EVENTNAME");	
		structdelete(res.account, "PROCESSOR");
		structdelete(res, "INTERCEPTEDINSTANCE");
		structdelete(res, "_INSTANCE");
		structdelete(res, "POSITION");
		structdelete(res, "METHODNAME");
		structdelete(res, "_METHODNAME");		
		if (!isnull(res.mainInvocation)){			
			structdelete(res.mainInvocation, "INTERCEPTEDINSTANCE");
			structdelete(res.mainInvocation, "_INSTANCE");
		}
							
		return res;
	}


	public any function argumentsCleaner(required any args){
		var objectCollection = [];
		var $data = [];
		for (local.key in args) {
			if ( isSimpleValue(args[key]) ) {							
				var objectStartPosition = findnocase("[",key);
				var objectEndPosition = findnocase("]",key);
				if ( val(objectStartPosition) && val(objectEndPosition) ) {
					var midCount = (objectEndPosition - objectStartPosition) - 1;					
					var $object = left(key, objectStartPosition-1);																	
					var $field = mid(key, objectStartPosition+1, midCount);
					var $value = args[key];					
					if ( ! val( arrayfind(objectCollection, $object) ) )
						arrayappend(objectCollection, $object);					
					$object = replacenocase(replacenocase(replacenocase($object, "po:", "", "all"), "o:", "", "all"), "np:", "", "all");										
					try {
						evaluate("args.#$object#.#$field# = '#$value#'");						
						structdelete(args, local.key);
					}
					catch(any e) {
						// writeDump(e);
					}				
				}
			}		
		}		
		args.objectCollection = objectCollection;		
		return args;
	}

	public any function getMemento(){
		this.attributes = variables;		
		return variables;
	}	
}
