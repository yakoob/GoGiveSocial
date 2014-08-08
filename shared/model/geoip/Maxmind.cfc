/**
* @displayname Maxmind
* @hint I am a singleton object representing MaxMind data service(s)
* @extends shared.model.Object
* @cfcommons:ioc:singleton
* @accessors true
*/
component{
	
	/**
    	* @type string
    	*/
    	property maxmindLicense;
	
	/**
	* @hint I am a handle on maxmind services
	* @type struct
	*/
	property geoIP;
	
	/**
    	* @hint I am a singleton result of maxmind attributes.  "eg: jar & datafiles..."
    	* @output true
    	*/
	public Maxmind function init(){
		super.init();
		geoIPinit();		
		variables.maxmindLicense = '';
		return this;
	}
	
    	/**
	* @output true
	* @hint I am going to initialize a structure of GeoIP Data file results.
	*/
	private void function geoIPinit(){		
		var result 	= {};
		var path 	= expandpath("../../");				
		path = path & "shared\model\geoip\data\";		
		var java 	= {};		
		java.Url 									= CreateObject("java", "java.net.URL").Init(JavaCast("string","file:#path#geoIP.jar" ));
		java.ArrayCreator							= CreateObject("java", "java.lang.reflect.Array");			
		java.URLArray 								= java.ArrayCreator.NewInstance(java.Url.GetClass(), JavaCast("int", 1));
		java.ArrayCreator.Set(java.URLArray, JavaCast("int", 0), java.Url);
		java.ClassLoader							= createObject("java", "java.net.URLClassLoader").init(java.URLArray);		
		java.lookupService							= createObject("java", "coldfusion.runtime.java.JavaProxy").init(java.ClassLoader.LoadClass("com.maxmind.geoip.LookupService"));									
		variables.geoIP.geoIpCity 					= java.lookupService.init(path & "GeoIPCity.dat",'LookupService.GEOIP_MEMORY_CACHE');
		variables.geoIP.geoIpIsp 					= java.lookupService.init(path & "GeoIPISP.dat",'LookupService.GEOIP_MEMORY_CACHE');
		variables.geoIP.geoIpOrg					= java.lookupService.init(path & "GeoIPOrg.dat",'LookupService.GEOIP_MEMORY_CACHE');
		variables.geoIP.geoIpRegionName				= createObject("java", "coldfusion.runtime.java.JavaProxy").init(java.ClassLoader.LoadClass("com.maxmind.geoip.regionName"));		
	}
	
	/**
    	* @output true
    	*/
    	public struct function minFraud(
		struct argStruct,
		string ipString="#CGI.REMOTE_ADDR#",
		string accountId=0,
		string address1='',
		string city='',
		string stateProvince='',
		string postalCode='00000',
		string countryCodeISO='US',
		string bin='',
		string phoneNumber='',
		string email='',
		string domain='',
		string username='',
		string password='')
	{	
		var reply= {
			'errorMessage' 		= '',
			'countryCode' 		= '',
			'ip_region' 		= '',
			'ip_city' 			= '',
			'ip_isp' 			= '',
			'ip_org' 			= '',
			'ip_latitude' 		= '',
			'ip_longitude' 		= '',
			'anonymousProxy' 	= '',
			'proxyScore' 		= '',
			'isTransProxy' 		= '',
			'freeMail' 			= '',
			'carderEmail' 		= '',
			'highRiskUsername'	= '',
			'highRiskPassword'	= '',
			'shipForward' 		= '',
			'riskScore' 		= '',
			'binCountry' 		= '',
			'binName' 			= '',
			'binPhone' 			= ''
		};
		
		// use argStruct if sent
		if ( StructKeyExists( arguments, 'argStruct' ) ) {
			for ( key in arguments.argStruct ) {
				arguments[ key ] = arguments.argStruct[ key ];
			}		
		}
		
		// determine requested_type (standard or premium)
		var requestType = 'standard';
		if ( len( arguments.bin) ) {
			requestType = 'premium';
		}
		
		// extract domain from email if valid email and domain not specified
		if ( IsValid( 'email', arguments.email ) && arguments.domain == '' ){
			// should be rewritten at some point to not use application scope...
			arguments.domain = application.domain.getDomain( arguments.email );
		}
		
		// build HTTP GET query string
		var httpGetURLString = '?i=' & arguments.ipString
		& '&city=' & UrlEncodedFormat( arguments.city )
		& '&region=' & UrlEncodedFormat( arguments.stateProvince )
		& '&postal=' & UrlEncodedFormat( arguments.postalCode )
		& '&country=' & arguments.countryCodeISO
		& '&domain=' & arguments.domain
		& '&bin=' & arguments.bin
		& '&custPhone=' & UrlEncodedFormat( arguments.phoneNumber )
		& '&license_key=' & maxmindLicense
		& '&requested_type=' & requestType
		& '&emailMD5=' & Hash( LCase( arguments.email ) )
		& '&usernameMD5=' & Hash( LCase( arguments.username ) )
		& '&passwordMD5=' & Hash( LCase( arguments.password ) )
		& '&shipAddr=' & UrlEncodedFormat( arguments.address1 )
		& '&shipRegion=' & UrlEncodedFormat( arguments.stateProvince )
		& '&shipPostal=' & UrlEncodedFormat( arguments.postalCode )
		& '&shipCountry=' & arguments.countryCodeISO
		& 'txnID=' & arguments.accountId;

		// send queryString to maxmind HTTP service
		var myHTTP = new Http( url='https://minfraud3.maxmind.com/app/ccv2r#httpGetURLString#', method='get', timeout='2', redirect='yes');
		var myHTTPresponse = myHTTP.send().getPrefix();
		
		// if timeout, set queryString sto minFraudURL2
		if ( Trim( myHTTPresponse.statusCode ) != '200 OK' ){
			myHTTP = new Http( url='https://minfraud1.maxmind.com/app/ccv2r#httpGetURLString#', method='get', timeout='2', redirect='yes');
			myHTTPresponse = myHTTP.send().getPrefix();
		}
		
		if ( Trim( myHTTPresponse.statusCode ) == '200 OK' ) {
			for ( var i=1; i<=ListLen( myHTTPresponse.fileContent, ';' ); i=i+1 ) {
				var avPair = ListGetAt( myHTTPresponse.fileContent, i, ';' );
				if ( ListLen( avPair, '=' ) == 1 ) {
					reply[ ListFirst( avPair, '=' ) ] = '';
				} else {
				reply[ ListFirst( avPair, '=' ) ] = ListLast( avPair, "=" );
				}
			}
		}

		return reply;
	}
}
