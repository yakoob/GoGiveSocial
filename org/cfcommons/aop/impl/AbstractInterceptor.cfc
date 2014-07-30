import org.cfcommons.aop.*;
import org.cfcommons.aop.impl.*;

/**
 * This abstract class provides default implementations of most of the necessary
 * plumbing required to both decorate a target object AND apply it's declared cross-cutting
 * concerns.  Of course, it is considered Abstract and should be extended in order to properly
 * type check aspectInstances.  Direct instantiation will throw an exception.
 */
component {
	
	public AbstractInterceptor function init() {
		throw(type="AbstractInstantiationException", message="The AbstractInterceptor must be considered an abstract class
			and cannot be instantiated directly.", detail="Please override this class and provide an implementation of
			$aop$runner() and optionally override interceptAt()");
	}
	
	public void function interceptAt(required any object, required string interceptedMethod, required any aspectInstance,
		required string aspectName, required string position, struct invokeArgs) {
		
		if (!structKeyExists(arguments.object, "_interceptors"))
			arguments.object._interceptors = {};
		
		if (!structKeyExists(arguments.object._interceptors, arguments.interceptedMethod)) {
		
			// create before, around, after and primary placeholders
			arguments.object._interceptors[arguments.interceptedMethod]["before"] = [];
			arguments.object._interceptors[arguments.interceptedMethod]["after"] = [];
			arguments.object._interceptors[arguments.interceptedMethod]["around"] = [];
			arguments.object._interceptors[arguments.interceptedMethod]["primary"] = "";
			
			// relocate the target method
			arguments.object["$#arguments.interceptedMethod#"] = arguments.object[arguments.interceptedMethod];
			
			// now replace the target method with a reference to the runInterceptors() delegate
			arguments.object[arguments.interceptedMethod] = runInterceptors;
			
			// set the around advice flag to false
			arguments.object._$executingAroundAdvice = false;
		}
		
		// is someone trying to apply more than one around aspect?
		if (arrayLen(arguments.object._interceptors[arguments.interceptedMethod]["around"]) == 1) {
			throw(type="NoMoreThanOneAroundAspectException", message="An 'around' aspect already exists for this point-cut.");
		}
		
		if (!structKeyExists(arguments.object, "_$runInterceptorsAtPosition")) {
		
			// decorate the object with a run interceptors method
			arguments.object._$runInterceptorsAtPosition = runInterceptorsAtPosition;
			
			// inject an instance of an aspect runner
			arguments.object._$setAspectRunner = setAspectRunnerTemplate;
			arguments.object._$getAspectRunner = getAspectRunnerTemplate;
			arguments.object._$setAspectRunner(runner = new AspectRunner());
		}
		
		// now add the aspect
		local.aspect = {
			instance = arguments.aspectInstance,
			methodName = arguments.aspectName,
			invokeArgs = arguments.invokeArgs
		};
		
		arrayAppend(arguments.object._interceptors[arguments.interceptedMethod][arguments.position], local.aspect);
	}
	
	public any function runInterceptors() {
	 
		local.intendedMethod = getFunctionCalledName();
		
		// special convenience variables
		arguments.pointCutName = local.intendedMethod;
		arguments.interceptedInstance = this;
		
		/**
		 * First things first; if an "around" aspect has been applied - then it takes
		 * precidence.  We will process the around adivce and let the interceptedInstance
		 * passed into it handle the aop execution moving forward.
		 */
		if (arrayLen(this._interceptors[local.intendedMethod]['around']) && !this._$executingAroundAdvice) {
			// first set the executing around advice flag to 'true' so we don't loop infinitely
			this._$executingAroundAdvice = true;
			// now delegate execution to the around advice
			arguments._instance = this._interceptors[local.intendedMethod]["around"][1]["instance"];
			arguments._methodName = this._interceptors[local.intendedMethod]["around"][1]["methodName"];
			// add invoke args
			structAppend(arguments, this._interceptors[local.intendedMethod]["around"][1]["invokeArgs"]);
			return this._$getAspectRunner().run(argumentCollection=arguments);
		}
			
		// run all before aspects now
		local.before = this._$runInterceptorsAtPosition(methodName=local.intendedMethod, position="before", argumentCollection=arguments);
		structAppend(arguments, local.before);
						
		// run the primary invocation now			
		arguments._instance = this;
		arguments._methodName = "$#local.intendedMethod#";
		local.main = this._$getAspectRunner().run(argumentCollection=arguments);
		// flag the results as the 'mainInvocation'
		arguments['mainInvocation'] = local.main;
		
		/*
		 * If the main invocation results are a structure - 
		 * append the results to the arg collection.
		 */
		if (isStruct(local.main) && !isObject(local.main))
			structAppend(arguments, local.main);
		
		// run all after aspects now
		local.after = this._$runInterceptorsAtPosition(methodName=local.intendedMethod, position="after", argumentCollection=arguments);
		structAppend(arguments, local.after);
		
		/*							
		 * Now that all cross-cutting concerns have had the opportunity to affect the outcome
		 * of the mainInvocation, we'll return that value. 
		 */
		return arguments['mainInvocation'];
	}
	
	public struct function runInterceptorsAtPosition(required string methodName, required string position) {
	
		for (local.i = 1; local.i <= arrayLen(this._interceptors[arguments.methodName][arguments.position]); local.i ++) {
				
			// pull the interceptor off the stack
			arguments._instance = this._interceptors[arguments.methodName][arguments.position][i]["instance"];
			arguments._methodName = this._interceptors[arguments.methodName][arguments.position][i]["methodName"];
			// add invoke args
			structAppend(arguments, this._interceptors[arguments.methodName][arguments.position][i]["invokeArgs"]);
			
			local.results = this._$getAspectRunner().run(argumentCollection=arguments);
			
			// make sure the results are made a part of the argument collection
			structAppend(arguments, local.results);
		}
		
		// clean up
		structDelete(arguments, "_instance");
		structDelete(arguments, "methodName");
		structDelete(arguments, "position");
		
		return arguments;
	}
	
	public void function setAspectRunnerTemplate(required AspectRunner runner) {
		variables._$aspectRunner = arguments.runner;
	}
	
	public AspectRunner function getAspectRunnerTemplate() {
		return variables._$aspectRunner;
	}

}