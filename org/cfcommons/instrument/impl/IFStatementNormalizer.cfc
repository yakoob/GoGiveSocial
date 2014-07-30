component implements="org.cfcommons.instrument.SourceInstrumenter" {

	public IFStatementNormalizer function init() {
	
		variables.state = new ScriptSourceState();
		variables.previousLine = "";
		variables.inDenormalizedIfStatement = false;
		variables.lastElse = false;
		variables.denormalizedIfLine = 0;
		variables.singleIf = false;
		variables.in$else$if = false;
		variables.else$if$count = 0;
		
		return this;
	}
	
	public string function instrument(required string sourceBeingTransformed) {
			
		var line = arguments.sourceBeingTransformed;
			
		variables.previousLine = line;
		variables.state.setLine(line);
	
		if (!variables.state.inMethod() && !variables.state.atEndOfMethod())
			return line;
			
		// are we entering a denormalized if statement?
		if (!variables.inDenormalizedIfStatement && refindNoCase("^if", trim(line)) && !refind("^.*\{$", trim(line))) {
			variables.inDenormalizedIfStatement = true;
			line = line & " {";
		}
		
		if (!variables.inDenormalizedIfStatement)
			return line;
			
		variables.denormalizedIfLine++;
			
		if (refindNoCase("^else.*if", trim(line))) {
			line = "} " & line & " {";
			variables.in$else$if = true;
			variables.else$if$count = 1;
			return line;
		}
		
		if (variables.in$else$if)
			variables.else$if$count++;
		
		if (variables.in$else$if && variables.else$if$count == 3 && !refindNoCase("^else", trim(line)))
			variables.lastElse = true;
		
		// 'else' conditionals are always last
		if (refindNoCase("^else", trim(line))) {
			line = "} " & line & " {";
			variables.lastElse = true;
			return line;
		}
		
		// is there an else?  we'll know if position three is empty
		if (variables.denormalizedIfLine == 3 && !refindNoCase("^else", trim(line)))
			variables.singleIf = true;
							
		// are we at the end?
		if (variables.lastElse || variables.singleIf) {
			
			line = line & " }";
			
			// finalize everything
			variables.lastElse = false;
			variables.inDenormalizedIfStatement = false;
			variables.singleIf = false;
			variables.denormalizedIfLine = 0;
		}
	
		return line;
	}
		
}