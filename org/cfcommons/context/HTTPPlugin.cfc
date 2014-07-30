import org.cfcommons.reflection.*;

/**
 * The HTTPPlugin plugin variant exposes a method which will allow
 * the context to retriev HTTP response information.
 */
interface extends="org.cfcommons.context.Plugin" {

	/**
	 * Implementations of this interface should expect
	 * to return a string representing data that will
	 * be returned to an HTTP client - such as HTML .JSON
	 * or some other meaningful web data stream.  The optional
	 * previous response argument may contain similar information
	 * produced by the HTTPPlugin's getResponse() method that preceed
	 * this call as all HTTPPlugins registered with the parent context
	 * will be asked for a response - the last response in the chain
	 * of HTTPPlugins will be pushed to the requesting client - so 
	 * the order that HTTPPlugins are registered with the Context is
	 * important.
	 * 
	 * HTTPPlugins that do not intend on altering the response of
	 * the previous invocation should return the response in the same
	 * condition in which it was provided to them.
	 */
	public string function getResponse(string response);
	
}