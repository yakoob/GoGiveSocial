import org.cfcommons.reflection.*;

/**
 * This interface must be implemented by any software wanting to dynamically alter
 * the behavior / API of a PluggableContext instance.
 */
interface {

	/**
	 * Any plugins registered as a plugin with a Context will have this method
	 * invoked when each class within the context is parsed.  The implementation
	 * of this method can expect to have available to it any contract methods
	 * exposed in the org.cfcommons.reflection.Class API - which is 
	 * the data-type of the class argument.  It is not necessary for a plugin
	 * to implement any logic in the read method if it is not necessary.
	 */
	public void function read(required any class);
	
	/**
	 * This method is invoked by the parent Context when the context has finished
	 * parsing all Classes.  Finalize() is invoked on each plugin consecutively, in 
	 * in the order in which they were passed to the createContext() method of the 
	 * ContextFactory, therefore Plugin implementations cannot guarantee that other plugins
	 * created and registered after this one have themselves been finalized at the time 
	 * this method is invoked by the Context.  It is important to use this method to ensure
	 * that the plugin is in a valid and useful state if necessary.
	 */
	public void function finalize();
	
	/**
	 * This method is very similar to the finalize() method in that it's only invoked
	 * by the parent Context after the context itself is done parsing all Classes - however
	 * the difference is that this method will get invoked after all registered Plugins have had
	 * their finalize() methods called - ensuring that whatever code exists in the implementation
	 * of this method has access to the context AND plugins that are in a final and useful state.
	 */
	public void function postContextConstruct();
	
	/**
	 * Must return a unique integer representing the current version of the plugin.  This is
	 * to ensure proper plugin interoperability.  If the plugin API OR BEHAVIOR change in any way
	 * from release to release, then this value MUST CHANGE.
	 */
	public numeric function getVersion();
	
	/**
	 * Makes the parent context available to the registered plugin.
	 */
	public void function setContext(required Context context);
	
}