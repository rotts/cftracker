<cfcomponent output="false">
	<cffunction name="init" output="false">
		<cfargument name="fw" />
		<cfset variables.fw = arguments.fw />
		<cfreturn this />
	</cffunction>

	<cffunction name="default" output="false" hint="Shows a list of running applications">
		<cfargument name="rc" />
	</cffunction>
	
	<cffunction name="getSettings" output="false">
		<cfargument name="rc" />
	</cffunction>
	
	<cffunction name="getScope" output="false">
		<cfargument name="rc" />
	</cffunction>
	
	<cffunction name="stop" output="false">
		<cfargument name="rc" />
		<cfscript>
			var lc = {};
			arguments.rc.apps = [];
			for (lc.key in arguments.rc) {
				if (ReFindNoCase('^app_\d+$', lc.key)) {
					ArrayAppend(arguments.rc.apps, arguments.rc[lc.key]);
				}
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="endstop" output="false">
		<cfargument name="rc" />
		<cfset variables.fw.redirect('applications.default') />
	</cffunction>
	
	<cffunction name="stopboth" output="false">
		<cfargument name="rc" />
		<cfset variables.stop(arguments.rc) />
	</cffunction>
	
	<cffunction name="endstopboth" output="false">
		<cfargument name="rc" />
		<cfset variables.endstop(arguments.rc) />
	</cffunction>
	
	<cffunction name="stopsessions" output="false">
		<cfargument name="rc" />
		<cfset variables.stop(arguments.rc) />
	</cffunction>
	
	<cffunction name="endstopsessions" output="false">
		<cfargument name="rc" />
		<cfset variables.endstop(arguments.rc) />
	</cffunction>
	
	<cffunction name="refresh" output="false">
		<cfargument name="rc" />
		<cfset variables.stop(arguments.rc) />
	</cffunction>
	
	<cffunction name="endrefresh" output="false">
		<cfargument name="rc" />
		<cfset variables.endstop(arguments.rc) />
	</cffunction>
	
	<cffunction name="restart" output="false">
		<cfargument name="rc" />
		<cfset variables.stop(arguments.rc) />
	</cffunction>
	
	<cffunction name="endrestart" output="false">
		<cfargument name="rc" />
		<cfset variables.endstop(arguments.rc) />
	</cffunction>
</cfcomponent>