import org.cfcommons.context.*;

component accessors="true" implements="org.cfcommons.context.ExceptionHandler" {

	property string type;
	property string className;
	property string methodName;
	property string viewTemplate;

	public ExceptionHandler function init() {
		return this;
	}

}