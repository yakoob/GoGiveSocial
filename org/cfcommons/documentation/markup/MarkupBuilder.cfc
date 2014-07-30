component {

	public MarkupBuilder function init() {
		variables.buildInstructions = [];
		variables.parseOrder = [];
		return this;
	}
	
	/**	
	 * Converts the MarkupBuilder instance
	 * to well-formed string representation, complete with proper
	 * tag-spacing and line-feeds.
	 */
	public string function toString() {
								
		// create the output
		var output = createObject("java", "java.lang.StringBuilder").init("");
		var text = "";
		var nextTag = "";
		var previousTag = variables.buildInstructions[1];
		var tagDelta = 0;
		
		// iterate over the instructions and build the resulting HTML
		for (var i = 1; i <= arrayLen(variables.buildInstructions); i++) {
						
			// previous tag reference
			if (i != 1) {
				var previousTag = variables.buildInstructions[local.i - 1];
			}
			
			// next tag reference			
			if (i != arrayLen(variables.buildInstructions)) {
				var nextTag =  variables.buildInstructions[local.i + 1];
			}
													
			var tag = variables.buildInstructions[local.i];
			local.tag.node.selfTerminate = false; 
								
			local.tagDelta ++;
			
			if (i == 1) {
				local.tagDelta--;
			}
			
			if (local.tag.mode.equals("end"))
				local.tagDelta--;
			
			if (i !=1 && local.previousTag.mode.equals("end")) {
				local.tagDelta--;
			}
			
			// only write spacing instructions if we're not in a contiguous tag instruction
			if (local.tag.mode == "end" && (local.tag.node.tagName == local.previousTag.node.tagName)) {
				// do nothing - we're in a contiguous instruction
			} else {
				local.output.append(indent(times=local.tagDelta));
			}
			
			if (structKeyExists(local.tag.node, "tagAttributes"))
				var tagAttrs = local.tag.node.tagAttributes;
				
			if (structKeyExists(local.tagAttrs, "text")) {
				var text = local.tagAttrs["text"];
				structDelete(local.tagAttrs, "text");
			}	
										
			// first, check to see if we're in a start tag without any text content
			if (local.tag.mode.equals("start") && local.nexttag.mode.equals("end") && (!len(trim(local.text)))) {
				local.tag.node.selfTerminate = true;
			}		
			
			// plain old start tag												
			if (local.tag.mode.equals("start")) {
				
				// open the tag
				local.output.append("<#local.tag.node.tagName#");
																
				// add attributes
				var attrList = structToAttributeString(attrs=tagAttrs);
								
				if (len(trim(local.attrList))) {
					local.output.append(" " & local.attrList);
				}
				
				// do we need to self-terminate this tag?
				if (local.tag.node.selfTerminate) {
					local.output.append(" />");
				} else {
					local.output.append(">");
				}
								
				// do we need to append text?
				if (len(trim(local.text))) {
					local.output.append(local.text);
					// now clear text
					local.text = "";
				}
									
			// make sure the previous tag was not self terminated
			} else if (!local.previousTag.node.selfTerminate) {
				local.output.append("</#local.tag.node.tagName#>");
			}
				
			if (!local.tag.node.tagName.equals(local.nextTag.node.tagName)) {
				local.output.append(chr(10));
			} else if (local.tag.mode == "end") {
				local.output.append(chr(10));
			}
		}

		return output.toString();
	}
	
	public xml function toXML() {
		return xmlParse(this.toString());
	}
	
	public any function indent(required numeric times) {
		var results = "";
		for (var i = 1; i <= arguments.times; i++) {
			local.results = local.results & chr(9);
		}
		
		return local.results;
	}
	
	public MarkupBuilder function onMissingMethod(required string missingMethodName,
		required struct missingMethodArguments) {
					
		var tagData = getTagData(methodName=arguments.missingMethodName,
			args=arguments.missingMethodArguments);
										
		var tagName = tagData.methodName;
		var args = tagData.args;
		
		if (isNull(variables.previousTagName))
			variables.previousTagName = local.tagName;
													
		if (local.tagName != "end") {
			startNode(name=local.tagName, attrs=local.args);
		} else {
			var previousNodeName = variables.parseOrder[arrayLen(variables.parseOrder)];
			endNode(name=local.previousNodeName);
		}
					
		return this;
	}
	
	public MarkupBuilder function addBuilder(required MarkupBuilder builder) {
		// simply add the instructions from the provided builder to this ones
		variables.buildInstructions.addAll(arguments.builder.getInstructions());
		
		return this;
	}
	
	public array function getInstructions() {
		return variables.buildInstructions;
	}
	
	private void function startNode(required string name, required struct attrs) {
		arrayAppend(variables.parseOrder, arguments.name);
		var node = {tagName = arguments.name, tagAttributes = arguments.attrs};
		arrayAppend(variables.buildInstructions, {mode="start", node=local.node});
	}
	
	private void function endNode(required string name) {
		var node = {tagName = arguments.name};
		arrayDeleteAt(variables.parseOrder, arrayLen(variables.parseOrder));
		arrayAppend(variables.buildInstructions, {mode="end", node=local.node});
	}
				
	private struct function getTagData(required string methodName, required struct args) {
					
		// is this a generic 'tag' invocation?
		if (arguments.methodName == 'tag' && structKeyExists(arguments.args, "name")) {
			var tagName = arguments.args["name"];
			// now remove it from the attributes structure
			structDelete(arguments.args, "name");
		} else {
			var tagName = arguments.methodName;
		}
		
		return {
			methodName = local.tagName,
			args = arguments.args
		};
	}
			
	public MarkupBuilder function each(required string tagName, required any collection) {
	
		// can only accept a query OR an array of structures
		if (isQuery(arguments.collection))
			arguments.collection = toStructArrayFormat(arguments.collection);
			
		if (!isNull(arguments.attributeMap)) {
			arguments.collection = convertObjectArrayCollection(arguments.collection, 
				arguments.attributeMap);
		}
						
		for (var i = 1; i <= arrayLen(arguments.collection); i++) {
			var argCollection = arguments.collection[i];
			this.addBuilder(new MarkupBuilder().tag(name=arguments.tagName, argumentCollection=argCollection).end());
		}
	
		return this;
	}
	
	public array function convertObjectArrayCollection(required array collection, required struct attributeMap) {
	
		var results = [];
	
		for (var i = 1; i <= arrayLen(arguments.collection); i++) {
		
			// grab the object reference
			var obj = arguments.collection[i];
			var args = {};
			
			for (attr in arguments.attributeMap) {
				if (isCustomFunction(obj[arguments.attributeMap[attr]]))
					args[attr] = evaluate("obj.#arguments.attributeMap[attr]#()");	
			}
			
			arrayAppend(results, args);
		}
		
		return results;
	}
	
	private array function toStructArrayFormat(required query qry) {
	
		var records = [];
			
		for (var i = 1; i <= arguments.qry.recordcount; i++) {
			var node = {};
			for (var c = 1; c <= listLen(arguments.qry.columnlist); c++) {
				var column = listGetAt(arguments.qry.columnlist, c);
				// only insert it if it does not already exist
				if (!structKeyExists(node, lcase(column)))
					structInsert(node, lcase(column), arguments.qry[column][i]);
			}
			arrayAppend(records, node);
		}
			
		// can return either an array or a structure
		return local.records;
	}
		
	private string function structToAttributeString(required struct attrs) {
			
		var attributesAsString = "";
		var count = 0;
		
		for (name in arguments.attrs) {
			// add a space to buffer the attributes only if we're not at the first element
			var attrSpacer = count ? " " : "";
			local.attributesAsString = listAppend(local.attributesAsString, 
				attrSpacer & name & '="' & arguments.attrs[name] & '"');
			count++;
		}
		
		return attributesAsString;
	}

}