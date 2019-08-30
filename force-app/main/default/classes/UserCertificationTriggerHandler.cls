/************************************************************************************************************************************
** Author: Salesforce Services
** Description: The purpose of this class is to complete the trigger actions with the help of the UserCertificationActions class 
************************************************************************************************************************************/

public without sharing class UserCertificationTriggerHandler {
/*    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public static boolean IsFromBachJob ;
    public static boolean isFromUploadAPI=false;
    
    public UserCertificationTriggerHandler(boolean isExecuting, integer size) {
        m_isExecuting = isExecuting;
        BatchSize = size;
    } */
    
    public UserCertificationTriggerHandler() {

    }            

    public void OnBeforeInsert(List<redwing__User_Certification__c> newUserCertifications) {
        system.debug('UserCertification Trigger On Before Insert');
        List<redwing__User_Certification__c> updateUserField = new List<redwing__User_Certification__c>();
        List<redwing__User_Certification__c> updateContactField = new List<redwing__User_Certification__c>();
        Set<Id> contactIds = new Set<Id>();
        Set<Id> userIds = new Set<Id>();
        for(redwing__User_Certification__c uc: newUserCertifications) {
            if(uc.Contact__c==null && uc.redwing__User__c!=null) {
                System.debug('--*UserCertification Contact is empty - populate using user*--');
                System.debug('*New UserCertification User:' + uc.redwing__User__c);
                updateContactField.add(uc);
                userIds.add(uc.redwing__User__c);
            } else if(uc.Contact__c!=null && uc.redwing__User__c==null) {
                System.debug('--*UserCertification User is empty - populate using contact*--');
                System.debug('*UserCertification Contact:' + uc.Contact__c);
                updateUserField.add(uc);
                contactIds.add(uc.Contact__c);
            } 
        }
        if(!updateUserField.isEmpty()) {
            UserCertificationActions.updateUserField(updateUserField, contactIds);
        }
        if(!updateContactField.isEmpty()) {
            UserCertificationActions.updateContactField(updateContactField, userIds);
        }
    }
/*    public void OnAfterInsert(List<redwing__User_Certification__c> newUserCertifications) {
        system.debug('UserCertification Trigger On After Insert');
    } 
    public void OnAfterUpdate( List<redwing__User_Certification__c> newUserCertifications, List<redwing__User_Certification__c> oldUserCertifications, Map<ID, redwing__User_Certification__c> newUserCertificationMap , Map<ID, redwing__User_Certification__c> oldUserCertificationMap ) {
        system.debug('UserCertification Trigger On After Update');
    } */
    public void OnBeforeUpdate( List<redwing__User_Certification__c> newUserCertifications, List<redwing__User_Certification__c> oldUserCertifications, Map<ID, redwing__User_Certification__c> newUserCertificationMap , Map<ID, redwing__User_Certification__c> oldUserCertificationMap ) {
        system.debug('UserCertification Trigger On Before Update');
        //Contact field was updated
        List<redwing__User_Certification__c> updateUserField = new List<redwing__User_Certification__c>();
        List<redwing__User_Certification__c> updateContactField = new List<redwing__User_Certification__c>();
        Set<Id> contactIds = new Set<Id>();
        Set<Id> userIds = new Set<Id>();
        for(redwing__User_Certification__c uc: newUserCertifications) {
            redwing__User_Certification__c oldUserCertification = oldUserCertificationMap.get(uc.id);
            if(uc.Contact__c!=oldUserCertification.Contact__c) {
                System.debug('--*UserCertification Contact is changed*--');
                System.debug('*Old UserCertification Contact:' + oldUserCertification.Contact__c);
                System.debug('*New UserCertification Contact:' + uc.Contact__c);
                if(uc.Contact__c!=null) {
                    updateUserField.add(uc);
                    contactIds.add(uc.Contact__c);
                } else {
                    uc.redwing__User__c=null;
                } 
            } else if(uc.redwing__User__c!=oldUserCertification.redwing__User__c) {
                System.debug('--*UserCertification User is changed*--');
                System.debug('*Old UserCertification User:' + oldUserCertification.redwing__User__c);
                System.debug('*New UserCertification User:' + uc.redwing__User__c);
                if(uc.redwing__User__c!=null) {
                    updateContactField.add(uc);
                    userIds.add(uc.redwing__User__c);
                } else {             
                    uc.Contact__c=null;
                }
            }
        }
        if(!updateUserField.isEmpty()) {
            UserCertificationActions.updateUserField(updateUserField, contactIds);
        }
        if(!updateContactField.isEmpty()) {
            UserCertificationActions.updateContactField(updateContactField, userIds);
        }
    }
/*
    @future 
    public static void OnAfterUpdateAsync(Set<ID> newUserCertificationIDs) {

    }      
    public boolean IsTriggerContext {
        get{ return m_isExecuting;}
    }
    
    public boolean IsVisualforcePageContext {
        get{ return !IsTriggerContext;}
    }
    
    public boolean IsWebServiceContext {
        get{ return !IsTriggerContext;}
    }
    
    public boolean IsExecuteAnonymousContext {
        get{ return !IsTriggerContext;}
    } */
}