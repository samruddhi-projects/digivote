public with sharing class Logger {
    private static transient final Boolean IS_LOGGING_ENABLED;
	
	
	static {
		try {
			//this flag define that custom logging is enable or not
			SysProperties__c logErrorDetailsConfig = RemedyforceSettings__c.getValues('propEnableLogging');
			IS_LOGGING_ENABLED = logErrorDetailsConfig != null 
										&& String.isNotBlank(logErrorDetailsConfig.Value__c) 
										&& boolean.valueOf(logErrorDetailsConfig.Value__c) ? true : false;

		}
		catch (Exception excep) {
			IS_LOGGING_ENABLED = false;
			logSystemDebugs(excep);
		}
	}

	/**
	  * @Description: A method to print debugs in debug logs.
	  */
	public static void logDebug(LoggingLevel logLevel, SObject sobj) {
		system.debug(logLevel, 'Message: ' + excep.getMessage());

	}
	
	/**
	  * @Description: A method to print debugs in debug logs.
	  */
	public static void logException(Exception excep) {
		system.debug(Logginglevel.ERROR, 'Message: ' + excep.getMessage());
        system.debug(Logginglevel.ERROR, 'Cause: ' + excep.getCause());
        system.debug(Logginglevel.ERROR, 'Line number: ' + excep.getLineNumber());
        system.debug(Logginglevel.ERROR, 'Stack trace: ' + excep.getStackTraceString());
		system.debug(Logginglevel.ERROR, 'Exception object: ' + excep);
	}
}