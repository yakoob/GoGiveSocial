<cfcomponent extends="org.cfcommons.documentation.classdoc.impl.CFCDocument"
	implements="org.cfcommons.documentation.XMLDocument">

	<cffunction name="init" access="public" returntype="org.cfcommons.documentation.XMLDocument">
		<cfargument name="class" type="org.cfcommons.reflection.Class" required="true" />
				
		<cfset variables.class = arguments.class />
		<cfreturn this />
	</cffunction>
		
	<cffunction name="toXML" access="public" returntype="xml">
	
		<cfset var document = "" />
		<cfset var hierarchy = variables.class.getHierarchy() />
		<cfset var interfaces = variables.class.getInterfaces() />
		<cfset var properties = variables.class.getProperties() />
		<cfset var allProperties = variables.class.getAllProperties() />
		<cfset var methods = variables.class.getMethods() />
		
		<cfxml variable="local.document">
		<cfoutput>
		<document type="#variables.class.getType()#">
			<class package="#variables.class.getPackage()#" type="#variables.class.getShortName()#">
			
				<hint>
					<cfif variables.class.hasAttribute('hint')>
					<![CDATA[#variables.class.getAttribute('hint')#]]>
					</cfif>
				</hint>
				
				<!--- //
					SECTION: Class Hierarchy
				// --->
				<hierarchy>
					<cfloop array="#hierarchy#" index="ancestor">
					<superclass package="#ancestor.getPackage()#" type="#ancestor.getShortName()#" />
					</cfloop>
				</hierarchy>
				
				<!--- //
					SECTION: Interfaces
				// --->
				<interfaces>
					
					<!--- // directly implemented interfaces // --->
					<direct>
						<cfloop array="#interfaces#" index="ifce">
						<class package="#ifce.getPackage()#" type="#ifce.getShortName()#" />
						</cfloop>
					</direct>
					
					<inherited>
						<!--- // inherited interfaces // --->
						<cfloop array="#hierarchy#" index="ancestor">
						
						<!--- // we only care about superclasses that are implementing interfaces themselves // --->
						<cfif !ancestor.isImplementing()>
							<cfcontinue />
						</cfif>
						
						<class package="#ancestor.getPackage()#" type="#ancestor.getShortName()#">
							<cfset var inheritedInterfaces = ancestor.getInterfaces() />
							<cfloop array="#inheritedInterfaces#" index="inheritedInterface">			
							<interface package="#inheritedInterface.getPackage()#" type="#inheritedInterface.getShortName()#" />
							</cfloop>
						</class>
						</cfloop>
						
					</inherited>
			
				</interfaces>
				
				<!--- //
					Direct properties are the properties that have
					been declared directly on the class.  This collection
					will not contain properties declared on any superclasses.
				// --->
				<properties>
				
					<direct>
						<cfloop array="#properties#" index="prop">
						<property name="#prop.name#" type="#prop.type#">
							<!--- // iterate and display all property keys and values // --->
							<cfloop collection="#prop#" item="key">
							
							<!--- // don't add name and type // --->
							<cfif key eq "name" or key eq "type">
								<cfcontinue />
							</cfif>
							
							<attr>
								<key><![CDATA[#key#]]></key>
								<value><![CDATA[#prop[key]#]]></value>
							</attr>
							</cfloop>
						</property>
						</cfloop>
					</direct>
					
					<inherited>
						<cfloop array="#allProperties#" index="prop">
						
						<!--- //
							Do not display properties declared on the current class
						// --->
						<cfif arrayContains(properties, prop)>
							<cfcontinue />
						</cfif>
						
						<!--- // don't add name and type // --->
						<cfif key eq "name" or key eq "type">
							<cfcontinue />
						</cfif>
						
						<property name="#prop.name#" type="#prop.type#">
							<!--- // iterate and display all property keys and values // --->
							<cfloop collection="#prop#" item="key">
							<attr>
								<key><![CDATA[#key#]]></key>
								<value><![CDATA[#prop[key]#]]></value>
							</attr>
							</cfloop>
						</property>
						</cfloop>
					</inherited>
					
				</properties>
				
				<cfif variables.class.hasConstructor()>
				<cfset var constructor = variables.class.getConstructor() />
				<constructor>
					<method name="#constructor.getName()#" accessModifier="#constructor.getAccess()#"
						returntype="#constructor.getReturnType()#">
						<signature>
							<cfloop array="#constructor.getParameters()#" index="param">
							<argument>
								
								<name>
								<cfif structKeyExists(param, "name")>#param.name#</cfif>
								</name>
								
								<type>
								<cfif structKeyExists(param, "type")>#param.type#</cfif>
								</type>
							
								<required>
								<cfif structKeyExists(param, "required")>#param.required#</cfif>
								</required>
								
								<default-value>
								<cfif structKeyExists(param, "default")>#param.default#</cfif>
								</default-value>
								
								<hint>
								<cfif structKeyExists(param, "hint")>#param.hint#</cfif>
								</hint>
								
							</argument>
							</cfloop>
						</signature>
						
						<annotations>
							<cfset var annotations = constructor.getAnnotations() />
							<cfloop collection="#annotations#" item="annotation">
							<name>#annotation#</name>
							<value>#annotations[annotation]#</value>
							</cfloop>
						</annotations>
						
						<cfif constructor.hasAttribute("hint")>
						<hint>#constructor.getAttribute("hint")#</hint>
						</cfif>
						
					</method>
				</constructor>
				</cfif>
				
				<methods>
					
					<cfloop array="#methods#" index="method">
					
						<!--- // don't add the constructor to this collection, we've already detailed
						that in the 'constructor' node // --->
						<cfif method.getName() eq constructor.getName()>
							<cfcontinue />
						</cfif>
					
						<method name="#method.getName()#" accessModifier="#method.getAccess()#"
							returntype="#method.getReturnType()#">
						<signature>
							<cfloop array="#method.getParameters()#" index="param">
							<argument>
								
								<name>
								<cfif structKeyExists(param, "name")>#param.name#</cfif>
								</name>
								
								<type>
								<cfif structKeyExists(param, "type")>#param.type#</cfif>
								</type>
							
								<required>
								<cfif structKeyExists(param, "required")>#param.required#</cfif>
								</required>
								
								<default-value>
								<cfif structKeyExists(param, "default")>#param.default#</cfif>
								</default-value>
								
								<hint>
								<cfif structKeyExists(param, "hint")>#param.hint#</cfif>
								</hint>
								
							</argument>
							</cfloop>
						</signature>
						
						<annotations>
							<cfset var annotations = method.getAnnotations() />
							<cfloop collection="#annotations#" item="annotation">
							<name>#annotation#</name>
							<value>#annotations[annotation]#</value>
							</cfloop>
						</annotations>
						
						<cfif method.hasAttribute("hint")>
						<hint>#method.getAttribute("hint")#</hint>
						</cfif>
						
					</method>
					
					</cfloop>
									
				</methods>
								
			</class>
		</document>
		</cfoutput>
		</cfxml>
	
		<cfreturn local.document />
	</cffunction>
	
	<cffunction name="transform" access="public" returntype="string">
		<cfargument name="xslt" type="string" required="true" />
		
		<!--- // transform it // --->
		<cfset var results = xmlTransform(toXML(), arguments.xslt) />
		<cfreturn local.results />
	</cffunction>
	
</cfcomponent>