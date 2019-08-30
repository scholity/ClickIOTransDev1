/************************************************************************************************************************************
** Author: Salesforce Services
** Description: *   Shares any budgets where the account field is populated with a partner account.
*   Read only access is given to the partner user group of the partner account. 
************************************************************************************************************************************/
trigger shareBudgetWithPartner on SFDC_Budget__c (after insert, after update) {
    
    /**
    *   Shares any budgets where the account field is populated with a partner account.
    *   Read only access is given to the partner user group of the partner account.
    *
    */
    
    if (!PHSS_TriggerSettings__c.getOrgDefaults().ShareBudgetWithPartnerDisabled__c) {
        ShareBudgetWithPartnerTriggerHandler handler = new ShareBudgetWithPartnerTriggerHandler();
        if (Trigger.isAfter && Trigger.isInsert) {
            handler.ShareBudgetWithPartner(Trigger.new,null,Trigger.newMap,null,true,false);
        } else if (Trigger.isAfter && Trigger.isUpdate) {
            handler.ShareBudgetWithPartner(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap, false, true);
        }
    }
    
}