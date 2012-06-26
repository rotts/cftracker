<cfcomponent output="false">
	<cffunction name="init" output="false">
		<cfargument name="fw" />
		<cfset variables.fw = arguments.fw />
		<cfreturn this />
	</cffunction>

	<cffunction name="default" output="false">
		<cfargument name="rc" />
	</cffunction>
	
	<cffunction name="endgc" output="false">
		<cfargument name="rc" />
		<cfif StructKeyExists(arguments.rc, 'return')>
			<cfset variables.fw.redirect(action = arguments.rc.return) />
		<cfelse>
			<cfabort>
		</cfif>
	</cffunction>
</cfcomponent>