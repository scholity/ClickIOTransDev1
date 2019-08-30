/************************************************************************************************************************************************************
** Author: Salesforce Services
** Description: This is a helper class. The purpose of this class is to hold the action details needed in the UserCertificationTriggerHandler class 
************************************************************************************************************************************************************/

public without sharing class UserCertificationActions {
    // Update User field on UserCertifications using Contact field
    public static void updateUserField(List<redwing__User_Certification__c> userCertificationList, Set<Id> contactIds) { 
        Map<Id, redwing__User_Certification__c> userCertificationMap = new Map<Id,redwing__User_Certification__c>();
        for(redwing__User_Certification__c cu: userCertificationList) {
            userCertificationMap.put(cu.Contact__c,cu);
        }
        // Query User records with ContactID populated with one of the provided list of Ids
        List<User> users = new List<User>([SELECT Id, ContactID FROM User WHERE ContactID IN:contactIds]);
        for(User u: users) {
            redwing__User_Certification__c userCertification = UserCertificationMap.get(u.ContactID);
            if(u.ContactID==UserCertification.Contact__c) {
                userCertification.redwing__User__c = u.Id;               
            }
        }
    }
    // Update Contact field on UserCertifications using User field
    public static void updateContactField(List<redwing__User_Certification__c> userCertificationList, Set<Id> userIds) { 
        Map<Id, redwing__User_Certification__c> userCertificationMap = new Map<Id,redwing__User_Certification__c>();
        for(redwing__User_Certification__c cu: userCertificationList) {
            userCertificationMap.put(cu.redwing__User__c,cu);
        }
        // Query User records with ContactID populated with one of the provided list of Ids
        List<User> users = new List<User>([SELECT Id, ContactID FROM User WHERE Id IN:userIds]);
        for(User u: users) {
            redwing__User_Certification__c userCertification = userCertificationMap.get(u.Id);
            if(u.Id==userCertification.redwing__User__c) {
                userCertification.Contact__c = u.ContactID;               
            }
        }
    }  
}