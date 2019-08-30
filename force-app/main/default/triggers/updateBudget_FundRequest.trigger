trigger updateBudget_FundRequest on SFDC_MDF__c (after insert, after update, after delete, before insert, before update) {

    /*
     * Recalculates The FundRequest Amount on the Budget on insert, update, delete of a fund request.
     * Only those FundRequest are considered which are approved (approved__c = true)
     *
     */ 
	if (!PHSS_TriggerSettings__c.getOrgDefaults().updateBudgetFundRequestDisabled__c) {
        updateBudget_FundRequestTriggerHandler handler = new updateBudget_FundRequestTriggerHandler();
         if (Trigger.isAfter && Trigger.isInsert) {
            handler.updateBudget_FundRequest(Trigger.new, null, true,false,false);
        } 
        
        if (Trigger.isAfter && Trigger.isUpdate) {
            handler.updateBudget_FundRequest(Trigger.new, Trigger.old, false, true, false);
        }
        
        if (Trigger.isAfter && Trigger.isDelete) {
            handler.updateBudget_FundRequest(Trigger.new, Trigger.old, false, false,true);
        }
        if (Trigger.isBefore && Trigger.isInsert) {
            handler.updateFundRequestChannelManager(Trigger.new);
        } 
        if (Trigger.isBefore && Trigger.isInsert) {
            handler.updateFundRequestChannelManager(Trigger.new);
        } 
        
    }
    

}