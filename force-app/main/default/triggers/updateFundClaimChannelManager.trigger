trigger updateFundClaimChannelManager on SFDC_MDF_Claim__c (before insert, before update) {

    /**
    *   Update the Partner Owner field when the record is owned by a partner
    *
    */
     
     if (!PHSS_TriggerSettings__c.getOrgDefaults().UpdateFundClaimChannelManagerDisabled__c) {
        updateFundClaimChannelManagerHandler handler = new updateFundClaimChannelManagerHandler();
        if (Trigger.isBefore && Trigger.isInsert) {
            handler.updateFundClaimChannelManager(Trigger.new,true,false);
        } 
        if (Trigger.isBefore && Trigger.isUpdate) {
            handler.updateFundClaimChannelManager(Trigger.new,false,true);
        }
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