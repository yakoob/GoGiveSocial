import org.cfcommons.http.*;
import org.cfcommons.http.impl.*;

component accessors="true" {

	property ResourceMapping resourceMapping;
	property URLMatcher urlMatcher;
	
	public RestRequestMatcher function init() {
		return this;
	}

}