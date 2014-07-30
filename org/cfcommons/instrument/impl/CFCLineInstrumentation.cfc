import org.cfcommons.instrument.*;
import org.cfcommons.reflection.*;

/**
 * An implementation of the org.cfcommons.instrument.Instrumentation interface
 * which implements its instrumentation algorithm via getInstrumentedSource() method 
 * by stepping through each line of a CFC source code file one at a time 
 * and permitting the provided SourceInstrumenters an opportunity to modify
 * each provided source line.
 */
component implements="org.cfcommons.instrument.Instrumentation" {

	public CFCLineInstrumentation function init() {
		variables.transformers = [];	
		return this;
	}
	
	/**
	 * The implementation of this method will iterate through each line of the target source
	 * associated with the provided Class and feed each line to the instrumenter, eventually
	 * producing the instrumented source.  Final source does not preserve line-feeds / carriage-returns
	 * or tabs and is therefore not well-formed.
	 */
	public string function getInstrumentedSource(required Class class, required array instrumenters) {
	
		var path = arguments.class.getPath();
		var file = createObject("java", "java.io.File").init(path);
		var scanner = createObject("java", "java.util.Scanner").init(file);
		var newSource = createObject("java", "java.lang.StringBuilder");
		 
		while(scanner.hasNextLine()) {
		
			// grab the current line
			var line = scanner.nextLine();
			
			// give each instrumenter the opportunity to modify the source
			for (var i = 1; i <= arrayLen(instrumenters); i++) {
				var instrumenter = instrumenters[i];
				var line = instrumenter.instrument(line);
			}
			
			// ensure the resulting source is well-formed
			line = line & chr(10);
						
			// add it to the new source
			newSource.append(line);
		}
			
		// important
		scanner.close();
					
		return newSource.toString();	
	}

}