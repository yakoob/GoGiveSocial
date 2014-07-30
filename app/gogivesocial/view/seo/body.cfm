<cfoutput>
<cfloop array="#reply.seopagecontent#" index="i" ><#i.contentType()#>#i.content()#</#i.contentType()#></cfloop>
</cfoutput>
