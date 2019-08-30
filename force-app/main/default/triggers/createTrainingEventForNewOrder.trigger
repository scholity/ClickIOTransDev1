trigger createTrainingEventForNewOrder on Order (after insert, after update) {
    //Checks the controlling field from the PHSS Trigger settings custom setting field to enable or disable the trigger
     if (!PHSS_TriggerSettings__c.getOrgDefaults().CreateTrainingEventForNewOrderDisabled__c ) {
         //Creating an instance for the CreateTrainingEventForNewOrder trigger handler
        CreateTrainingEventForNewOrderHandler handler = new CreateTrainingEventForNewOrderHandler();
        //Executing after insert trigger 
        if (Trigger.isAfter && Trigger.isInsert) {
            handler.onAfterInsert(Trigger.new);
        } else if (Trigger.isAfter && Trigger.isUpdate) {
            //executing after update triggers
            handler.OnAfterUpdate(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
        }
  }    
}