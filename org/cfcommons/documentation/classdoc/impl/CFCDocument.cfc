import org.cfcommons.reflection.*;
import org.cfcommons.templating.impl.*;

component implements="org.cfcommons.documentation.Document" {

	public function init(required Class class) {
		variables.class = arguments.class;
	}
	
	public string function getName() {
		return variables.class.getShortName();
	}
				
}