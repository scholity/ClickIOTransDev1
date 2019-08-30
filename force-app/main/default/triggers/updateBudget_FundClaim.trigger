trigger updateBudget_FundClaim on SFDC_MDF_Claim__c (after insert, after update, after delete, after undelete) {

    /*
     * Recalculates The FundClaim Amount on the Budget on insert, update, delete of a fund claim.
     * Only those FundClaims are considered which are approved (approved__c = true)
     *
     */ 
    if (!PHSS_TriggerSettings__c.getOrgDefaults().updateBudgetFundClaimDisabled__c) {
        updateBudget_FundClaimTriggerHandler handler = new updateBudget_FundClaimTriggerHandler();
        if (Trigger.isAfter && Trigger.isInsert) {
            handler.updateBudget_FundClaim(trigger.new,trigger.old,true,false,false,false);
        }
        if (Trigger.isAfter && Trigger.isUpdate) {
            handler.updateBudget_FundClaim(trigger.new,trigger.old,false,true,false,false);
        }
        if (Trigger.isAfter && Trigger.isDelete) {
            handler.updateBudget_FundClaim(trigger.new,trigger.old,false,false,true,false);
        }
        if (Trigger.isAfter && Trigger.isUnDelete) {
            handler.updateBudget_FundClaim(trigger.new,trigger.old,false,false,false,true);
        }
        
    }
}