component output=false {

	public ip function init() {
		return this;
	}
	
	// getDisplay calls private function ipGetHTTP to get IP info, then creates string based on rules to return to user
	// stores userLocation in session
	public string function userLocation(required string ip = cgi.remote_addr) {		
		session.meeting.userLocation = "";		
		local.ipStruct = ipGetHTTP(arguments.ip);		
		local.cityCleaned = ipStruct.address.city;
		local.countryCleaned = ipStruct.country.countryName;
		local.regionContryName = ipStruct.region.countryregionname;	
		local.countryRegionCode = ipStruct.address.countryregioncode;
		
		if ( trim(ipStruct.address.countryCodeISO) == 'us' || trim(ipStruct.address.countryCodeISO) == 'ca' ) {
			if ( len(cityCleaned) )
				session.meeting.userLocation = session.meeting.userLocation & cityCleaned;			
			if ( len(regionContryName) )
				session.meeting.userLocation = session.meeting.userLocation & ", " & regionContryName;
			else if ( len(countryRegionCode) )
				session.meeting.userLocation = session.meeting.userLocation & ", " & countryRegionCode;
		}
		else {
			countryCleaned = replaceNoCase(countryCleaned, 'Republic of','');
			countryCleaned = replaceNoCase(countryCleaned, 'Anonymous Proxy','');
			countryCleaned = replaceNoCase(countryCleaned, 'Dem Republic','');
			countryCleaned = replaceNoCase(countryCleaned, 'Satelling Provider','');
			countryCleaned = replaceNoCase(countryCleaned, 'Dem Republic','');
			countryCleaned = replaceNoCase(countryCleaned, 'n Federation','');
			countryCleaned = trim(countryCleaned);			
			session.meeting.userLocation = countryCleaned;
		}						
		return session.meeting.userLocation;
	}
	
	// ipGetHTTP consumes remote ip service
	private struct function ipGetHTTP(required string ip) {	
		// Prepare a new HTTP object.
		local.httpCall = new Http( url='/index.cfm/ipaddress/partial.json?ip=' & arguments.ip, method='get' );
		
		// Send to uri. We get back a JSON representation of a query object. Dump _httpResponse to see all available values.
		return DeserializeJSON( local.httpCall.send().getPrefix().fileContent.toString(), false );
	}

}

