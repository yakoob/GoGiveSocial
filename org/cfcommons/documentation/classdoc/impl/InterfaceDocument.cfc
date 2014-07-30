import org.cfcommons.reflection.*;
import org.cfcommons.templating.impl.*;

component extends="org.cfcommons.documentation.impl.CFCDocument" {

	public function init(required Class class) {
		return super.init();
	}
	
	public string function getName() {
		return variables.name;
	}
	
	public string function toString() {
		
		var stringRepresentation = '
			<html>
				<head>
					<title>Documentation</title>
				</head>
				<body>
				
					<div id="header">
						#getHeaderInsert()#
					</div>
					
					<div id="superclasses">
						#getSuperclassesInsert()#
					</div>	
					
				</body>
			</html>		
		';
		
		return trim(local.stringRepresentation);
	}
		
	private string function getHeaderInsert() {
	
		var homeLink = variables.linkTemplate.replace({
			_page_ = "/index.html",
			_text_ = variables.class.getPackage()
		});
	
		var insert = '
			<div class="header">
				<div class="package">#homeLink#</div>
				<div class="classname">#variables.class.getShortName()#</div>
			</div>
		';
				
		return insert;
	}
	
	private string function getSuperclassesInsert() {
	
		var homeLink = variables.linkTemplate.replace({
			_page_ = "/index.html",
			_text_ = variables.class.getPackage()
		});
					
		var classes = 
			
		var insert = '
			<div class="header">
				<div class="package">#homeLink#</div>
				<div class="classname">#variables.class.getShortName()#</div>
			</div>
		';
				
		return insert;
	}
	
	private Class[] function getSuperClasses() {
	
		var classes = [];
	
		if (!variables.class.isSubclass()) {
			return "";
		}
		
		if (variables.class.getType() == "component") {
			var superClass = variables.class.getSuperClass();
			arrayAppend(classes, superClass);
		} else {
			var classes = variables.class.getSuperClasses();
		}
	
		return classes;
	}
		
}