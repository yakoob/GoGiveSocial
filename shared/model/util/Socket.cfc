/** 
* @hint Provides Raw socket functionality.
* @output false
* @name socket
*/
component {

	/**
	* @output false
	*/
	public Socket function init(string hostname="", numeric port=80, boolean useSsl=false, numeric timeout=30){		
		try{
			StructInsert(variables, "instance", StructNew());
		}
		catch(any e){
			writedump(e);		
		}						
		if (arguments.UseSSL)
			setProperty("socketFactory", createObject("java","javax.net.ssl.SSLSocketFactory").getDefault());
		else
			setProperty("socketFactory", createObject("java","javax.net.SocketFactory").getDefault());			
		setProperty("hostname", arguments.hostname);
		setProperty("port", arguments.port);
		setProperty("timeout", arguments.timeout);
		setProperty("UseSSL", arguments.UseSSL);		
		return this;					
	}
	
	/**
	* @output false
	*/	
	public boolean function setProperty(required string property, required any propertyValue){
		StructInsert(variables["instance"], arguments.property, arguments.propertyValue, true);
		return true;		
	}
	
	/**
	* @output false
	*/
	public any function getProperty(required string property){		
		return variables["instance"][arguments.property];	
	}
		
	/**
	* @output false
	*/
	private boolean function propertyExists(required string property){		
		return StructKeyExists(variables.instance, arguments.property);	
	}		

	/**
	* @output false
	*/
	public boolean function connect(){
		var sout = "";
		setProperty("sock", variables["instance"]["socketFactory"].createSocket(getProperty("hostname"), JavaCast("int", getProperty("port"))));			
		getProperty("sock").setSoTimeout(JavaCast("int", getProperty("timeout")*1000));		
		if (getProperty("sock").isConnected()) {
			sout = getProperty("sock").getOutputStream();
			setProperty("out", createObject("java", "java.io.PrintWriter").init(sout));
		}
		return getProperty("sock").isConnected();				
	}	

	/**
	* @output false
	*/
	public boolean function write(required string string){		
		getProperty("out").println(arguments.string);
		getProperty("out").flush();
		return true;
	}	
	
	/**
	* @output false
	*/
	public string function read(){
		var result = "";
		var sinput = getProperty("sock").getInputStream();
		var inputStreamReader = createObject("java", "java.io.InputStreamReader").init(sinput);
		var locInput = createObject("java", "java.io.BufferedReader").init(InputStreamReader);
		var timeout = getTickCount()+(getProperty("timeout")*1000);
		var outputStream = createObject("java", "java.io.StringWriter");
		if (getProperty("sock").isConnected()){			
			while (!locInput.ready()) {
				sleep(1);
				if(timeout LT getTickCount()){				
					writedump("connection timed out");
					abort;
				}				
			}			
			while(locInput.ready()){
				outputStream.write(locInput.read());
				result = outputStream.toString();	
			}			
		}
		else {
			writedump("Not connected.");
			abort;
		}
		return result;			
	}
		
	/**
	* @output false
	*/
	public string function readToEOM(string EOM="#chr(13)##chr(10)#.#chr(13)##chr(10)#"){
		var result = read();
		while(result does not contain arguments.EOM){
			result = result & read();
		}
		return result;
	}
	
	public boolean function close(){
		if (propertyExists("out"))
			getProperty("out").close();
		if (propertyExists("input"))		
			getProperty("input").close();
		if (propertyExists("sock"))		
			getProperty("sock").close();
		return true;
	}
	
	/**
	* @output false
	*/
	public boolean function isClosed(){
		if (propertyExists("sock"))
			return getProperty("sock").isClosed();
		return true;		
	} 
	
	/**
	* @output false
	*/
	public any function test(string hostname="gogreensocial.com", string string="GET /", numeric port=80){
		var result = "";
		setProperty("hostname", arguments.hostname);
		setProperty("port", arguments.port);			
		try{
			if (connect()) {
				write(arguments.string);
				sleep(500);
				result = read();
				close();				
			}			
		}
		catch(any e){
			if (!isClosed())
				close();	
			writedump(e);		
		}		
		return result;		
	}	

}




















