/************************************************************************************************************************************
** Author: Salesforce Services
************************************************************************************************************************************/
trigger UserCertificationTrigger on redwing__User_Certification__c (before insert, before update) {
	if (!PHSS_TriggerSettings__c.getOrgDefaults().UserCertificationTrigger_Disabled__c) {
        UserCertificationTriggerHandler handler = new UserCertificationTriggerHandler();
        if (Trigger.isBefore && Trigger.isInsert) {
            handler.onBeforeInsert(Trigger.new);
        } else if (Trigger.isBefore && Trigger.isUpdate) {
            handler.onBeforeUpdate(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
        }
	}
}