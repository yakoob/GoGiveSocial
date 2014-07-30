interface {

	public any function getObjectInstance(required string className, struct initArgs=structNew());
	public any function decorateObjectInstance(required any object, required string className);
	public void function addDecorator(required ObjectDecorator decorator);
	public void function setContext(required Context context);

}