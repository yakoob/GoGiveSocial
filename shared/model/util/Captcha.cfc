/**
* @accessors true
* @extends shared.model.Object
*/
component {

	/**
	* @type string
	*/
	property encryptionKey;
	
	/**
	* @type string
	*/
	property systemCaptcha;
	
	/**
	* @type string
	*/
	property userCaptcha;
	
	public Captcha function init(){
		super.init();
		if (!isnull(session.captcha)){
			this.setEncryptionKey(session.captcha.getEncryptionKey());
			this.setSystemCaptcha(session.captcha.getSystemCaptcha());
		}
		return this;
	}
	
	public struct function generate(){		
		var arrValidChars 	= ListToArray("A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,1,2,3,4,5,6,7,8,9");		
		CreateObject("java","java.util.Collections").Shuffle(local.arrValidChars);
		this.setEncryptionKey("GGS@1#randrange(4444,999999)#ckth1sk3y");
		this.setSystemCaptcha((local.arrValidChars[1] & local.arrValidChars[2] & local.arrValidChars[3] & local.arrValidChars[4]));		
		invoke.SessionManager().Captcha(this);		
		return this;
	}
	
	public boolean function validate(){
		if( trim(this.getSystemCaptcha()) != trim(this.getUserCaptcha()) )
			this.getError().add("captch text is invalid...");							
		return super.validate();		
	}
	
		
}
