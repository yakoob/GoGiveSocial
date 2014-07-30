interface {
	
	/**
	 * The keyValues argument should contain a structure containing
	 * keys that map directly to specific textual elements within the template
	 * itself, the key values should represent replacement values for the
	 * specified keys.  If the key is found in the template, then it is replaced
	 * with it's structure value.  The method returns the augmented template
	 * as a string, will all template keys replaced with the provided values.
	 */
	public string function replace(required struct keyValues);
	public string function getContent();

}