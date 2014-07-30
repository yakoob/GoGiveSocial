interface {

	/**
	 * It is the responsibility of implementations of this interface to decorate a provided
	 * object instance with correct AOP cross-cutting conernts.
	 */
	public void function interceptAt(required any object, required string interceptedMethod, required any aspectInstance,
		required string aspectName, required string position, struct invokeArgs=structNew());

}