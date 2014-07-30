/**
* @displayname IpAddress
* @extends shared.model.Object
* @persistent true
* @accessors true
*/
component {

	/**
	* @fieldtype id
	* @generator native
	* @column ipAddressId
	*/
	property id;

	
	/**
	* @type shared.model.geography.Country	
	* @persistent false
	*/
	property country;
	
	/**
	* @type shared.model.geography.CountryRegion
	* @persistent false
	*/
	property region;
	
	/**
	* @type string
	* @default ''
	* @setter false
	*/	
	property ip;

	/**
	* @type string
	*/	
	property isp;
		
	/**
	* @type string
	* @update false
	* @insert false
	* @default 'US'
	*/	
	property iso;
	
	/**
	* @type string
	* @update true
	* @insert true
	*/	
	property code;
		
	/**
	* @type string
	*/	
	property city;
	
	/**
	* @type string
	*/
	property postalCode;
	
	/**
	* @type numeric
	* @default 0
	*/	
	property latitude;
		
	/**
	* @type numeric
	* @default 0
	*/	
	property longitude;
		
	/**
	* @type string
	*/	
	property organization;
		
	/**
	* @type boolean	
	*/	
	property isAnonymousProxy;
	
	/**
	* @type numeric
	*/	
	property proxyScore;
	
	/**
	* @type boolean
	* @default false
	*/	
	property isEmployeeId;
	
	/**
	* @type date
	*/
	property dateLast;
	
	/**
	* @type date
	*/
	property dateNext;	

	public IPAddress function init() {		
		return this;
	}
	
	public void function setIp(required string ip){					
		variables.ip = arguments.ip;
		partialDetails();		
	}
	
	
	
	public IPAddress function refresh() {				
		var mm 							= invoke.Maxmind().minFraud( ipString = this.getIp() );		
		variables.Iso 					= mm.countryCode;		
		variables.code 					= mm.ip_region;
		variables.city 					= mm.ip_city;
		variables.latitude 				= mm.ip_latitude;
		variables.longitude 			= mm.ip_longitude;
		variables.isp 					= mm.ip_isp;
		variables.organization 			= mm.ip_org;
		variables.isAnonymousProxy 		= mm.anonymousProxy;
		variables.proxyScore 			= mm.proxyScore;			
		myCountry();
		myRegion();
		resetDates();
		// persist this
		return save(); // keep the chain going
	}
	
	/**
    * @hint I provide results based on either SQL data or Maxmind().minFraud() webservice
    * @output true
    */
	public any function fullDetails() {
		try {
			var ipAddress = where({ip=this.getIp()})[1];
			objToObj(ipAddress);
		}
		catch(any e){
			// dont worry we still have "this"
		}
		if ( refreshRequired() )																			
			refresh();		
		myCountry();
		myRegion();					
		return this;						
	}	
	
	/**
    * @hint 
    * @output true
    */
	public struct function partialDetails() {			
		var maxmind = invoke.maxmind().geoIP();		
		// instantiate the Java objects
		var structGeoIP = maxmind.geoIPCity.getLocation( this.getIp() );		
		var gotGeoIPISP = maxmind.geoIPISP.getOrg( this.getIp() );
		var gotGeoIPOrg = maxmind.geoIPOrg.getOrg( this.getIp() );		
		
		// if geoIPCity.getLocation() returned anything, use it to populate ipAddress's properties
		if ( IsDefined( 'structGeoIP' ) ) {
			try{ this.setCity( structGeoIP.city ); }catch (any e){ }
			try{ this.setLatitude( structGeoIP.latitude ); }catch (any e){ }
			try{ this.setLongitude( structGeoIP.longitude ); }catch (any e){ }
			try{ this.setIsp( gotGeoIPISP ); }catch (any e){ }
			try{ this.setOrganization( gotGeoIPOrg ); }catch (any e){ }			
			try{ this.setCode( structGeoIP.region ); }catch (any e){ }
			try{ this.setIso( structGeoIP.countryCode ); }catch (any e){ }
			try{ this.setPostalCode( structGeoIP.postalCode ); }catch (any e){ }
			myCountry();			
			myRegion();
		}		 							
		return this;
	}

	private void function myCountry(){
		// if the country was persisted, use that; else create empty Country object
		var country = invoke.country().findbyISO( this.getIso() );
		if ( Arraylen( country ) ) {
			country = country[1];
		} else {
			country = invoke.Country();
		}
		this.setCountry( country );
		// this.setcountryName(country.countryName());		
	}
	
	private void function myRegion(){		
		// if the region was persisted, use that; else create empty CountryRegion object
		var region = invoke.countryRegion().where( {iso=this.iso(), code=this.code()} );
		if ( Arraylen( region ) ) {
			region = region[1];
		}	else {
			region = invoke.CountryRegion();
		}		
		this.setRegion( region );		
	}
		
	private boolean function refreshRequired(){						
		// if we don't have a dateNext or dateNext is prior to now, we need a refresh
		if ( Len( this.getDateNext() ) < 1 || this.getDateNext() < now() ) 			
			return true;						
		return false;		
	}
	
	/**
	* @hint I persist myself
	* @output false
	*/
	public IPAddress function save(){
		var findIp = invoke.IpAddress().findByIp(this.getIp());
		if (arraylen(findIp))
			this.setId(findIp[1].getId());		
			
		if ( !val(this.getDateLast()) || !val(this.getDateNext()) )
			resetDates();
				
		try {			
			return super.save();
		}
		catch(any e) {
			// i dont persist local IP's so im gana return "this"
			// this.setIsp("Error - " & this.getIsp());
			return this;
		}
		
	}

	/**
	* @hint setup "date next" & "date last" for runtime refresh logic
	* @output false
	*/	
	private function resetDates(){
		this.setDateNext(dateformat(now()+90, "full"));
		this.setDateLast(dateformat(now(), "full"));	
		return true;
	}
	
	/**
    * @hint Receiving an ip address string, I return the integer representation
    * @output true
    */
	public numeric function ipToInteger(){		
		if ( ListLen( this.getIp(), '.' ) != 4 ) { return 0; }	
		var w = ListGetAt( this.getIp(), 1, '.' );
		var x = ListGetAt( this.getIp(), 2, '.' );
		var y = ListGetAt( this.getIp(), 3, '.' );
		var z = ListGetAt( this.getIp(), 4, '.' );	
		return ( 16777216 * w ) + (65536 * x) + (256 * y) + z;
	}
	
	/*
    * @hint Receiving an ip integer, I return an ip address string
    * @output true
   
	public string function integerToIp() {
		// var w = Int( this.getID() / 16777216 ) MOD 256;
		// var x = Int( this.getID() / 65536 ) MOD 256;
		// var y = Int( this.getID() / 256 ) MOD 256;
		// var z = this.getID() - ( w * 16777216 ) - ( x * 65536 ) - ( y * 256 );			
		return ToString( w ) & '.' & ToString( x ) & '.' & ToString( y ) & '.' & ToString( z );		
	} */
	
	private boolean function isPrivateIp(){		
		if ( findnocase("192.168.20.", this.getIp()) )
			return true;
		if ( findnocase("10.20.1.", this.getIp()) )
			return true;
		if ( findnocase("192.168.0.", this.getIp()) )
			return true;
		if ( findnocase("127.0.0.1", this.getIp()) )
			return true;
		return false;
	}
	
	public string function friendlyIp(){
		if (isPrivateIp())
			return "68.5.232.78";
		else
			return this.getIp();
	}	
	
		
}
