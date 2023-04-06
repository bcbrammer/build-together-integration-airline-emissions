public class TriggerFramework {
	// Flag that determines whether the trigger should be disabled
  public static Boolean isDisabled = false;
  // Set of users that the trigger should be skipped for
  public static Set<Id> skippedUsers = new Set<Id>();
  // Set of records that are currently being processed by the trigger
  private static Set<Id> processingRecords = new Set<Id>();
  // Map of trigger handlers
  private static Map<String, List<TriggerHandler>> triggerHandlers = new Map<String, List<TriggerHandler>>();
  // Register a trigger handler
  public static void registerHandler(String objectName, TriggerHandler handler) {
    // Get the list of trigger handlers for the object
    List<TriggerHandler> handlers = triggerHandlers.get(objectName);
    // If the list doesn't exist, create it
    if (handlers == null) {
      handlers = new List<TriggerHandler>();
      triggerHandlers.put(objectName, handlers);
    }
    // Add the trigger handler to the list
    handlers.add(handler);
  }
    
    
  // Method that is called by the triggers
  public static void run(List<SObject> newList, List<SObject> oldList) {
    // Check if the trigger is disabled or if it is running in a test context
    if (isDisabled || Test.isRunningTest()) {
      return;
    }
    // Get the object name
    String objectName = newList[0].getSObjectType().getDescribe().getName();
    // Get the list of trigger handlers for the object
    List<TriggerHandler> handlers = triggerHandlers.get(objectName);
    // If there are no registered handlers, exit
    if (handlers == null) {
      return;
    }
    // Loop through the new records
    for (Integer i = 0; i < newList.size(); i++) {
      // Get the current record
      SObject newRecord = newList[i];
      SObject oldRecord = oldList[i];
      // Check if the trigger should be skipped for the current user
      if (skippedUsers.contains(UserInfo.getUserId())) {
        continue;
      }
      // Check if the record is already being processed
      if (processingRecords.contains(newRecord.Id)) {
        continue;
      }
      // Add the record to the set of records being processed
      processingRecords.add(newRecord.Id);
      // Loop through the trigger handlers and run them
      for (TriggerHandler handler : handlers) {
        handler.run(newRecord, oldRecord);
      }
      // Remove the record from the set of records being processed
      processingRecords.remove(newRecord.Id);
    }
  }
}