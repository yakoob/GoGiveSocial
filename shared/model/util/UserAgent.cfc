/**
* @hint Analyzes a web browser or bot user agent for properties.
* @cfcommons:ioc:singleton
*/ 


component output=false {

	public UserAgent function init() {
		return this;
	}
	
	public boolean function isBot(required string ua) {
		if (
			REFindNoCase('slurp|ia_archiver|scoutjet|facebookexternalhit|python-urllib|libwww-perl|scanning engine',ua) // Specific, don't need to anchor.
			or REFindNoCase('(crawler|bots?|spider|validator|verification)\b',ua) // anchor at end of word but not beginning (catch XYZbot).
			or REFindNoCase('^Java', ua) // Plain Java 
		)  {
			return true;
		}
		return false;
	}
}