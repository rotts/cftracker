<cfscript>
	settings = StructNew();
	// Access settings
	settings.security.password = 'password';
	settings.adminpassword = '';
	settings.security.maxattempts = 5;
	settings.security.lockperiod = CreateTimeSpan(0, 0, 5, 0);
	// Display settings	
	settings.display.dateFormat = 'yyyy-mm-dd';
	settings.display.timeFormat = 'HH:mm:ss';
	// Dashboard settings
	settings.dashboard.updateInterval = 5000;
</cfscript>