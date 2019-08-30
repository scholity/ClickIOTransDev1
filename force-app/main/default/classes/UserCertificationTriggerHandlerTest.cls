/************************************************************************************************************************************
** Author: Salesforce Services
** Description: Tests for UserCertificationTriggerHandler and UserCertificationActions 
************************************************************************************************************************************/

@isTest
private class UserCertificationTriggerHandlerTest {

    @testSetup static void setup() {
        // Create portal account owner
        User portalAccountOwner = new User(
            UserRoleId = [Select Id From UserRole Where PortalType = 'None' LIMIT 1].Id,
            ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1].Id,
            LastName = 'last222',
            Email = 'test22222@testingARC.com',
            Username = 'test22222@testingARC.com' + System.currentTimeMillis(),
            CompanyName = 'ARC222',
            Title = 'title222',
            Alias = 'test222',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8', 
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert portalAccountOwner; 
        
        Bucket_Account_Settings__c bas = new Bucket_Account_Settings__c();
        bas.Bucket_Account_Owner_ID__c ='005d0000001WOeV';
        bas.Bucket_Account_RecordTypeID__c = '012d000000098Wt';
        bas.Default_Bucket_Name__c = 'Bucket Account';
        bas.Maximum_Size_of_Bucket__c = 5000;
        System.runAs(portalAccountOwner) {
        insert bas;  
        // Create an Account
        Account newAccount = new Account(Name='Bucket Account', OwnerId=UserInfo.getUserId());
        insert newAccount;        
        // Create Contacts
        List<Contact> testContacts = new List<Contact>();
        for(Integer i=0;i<2;i++) {
            testContacts.add(new Contact(FirstName='First11 ' + i, LastName='Last11 ' + i, AccountId=newAccount.Id));
        }
        insert testContacts;             
        }
        // Create user
        Contact c = [SELECT Id, FirstName, LastName FROM Contact WHERE FirstName='First11 0' LIMIT 1];           
        User user1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name='Learner Community Profile'].Id,
            LastName = 'last111',
            Email = 'test11111@testingARC.com',
            Username = 'test11111@testingARC.com' + System.currentTimeMillis(),
            CompanyName = 'ARC111',
            Title = 'title111',
            Alias = 'test111',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8', 
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ContactId = c.Id           
        );    
        insert user1;
    }
    
    // Test UserCertification Before Insert, Before Update
    // Scenario: UserCertification is created, with contact, no user included
    static testMethod void createUserCertification_createUpdate_withContact() {
        // Create UserCertification
        User portalAccountOwner = [SELECT Id FROM User WHERE Email='test22222@testingARC.com' LIMIT 1];
        User portalUser = [SELECT Id FROM User WHERE Email='test11111@testingARC.com' LIMIT 1];
        Contact c = [SELECT Id FROM Contact WHERE FirstName='First11 0' LIMIT 1];

        redwing__User_Certification__c uc = new redwing__User_Certification__c(Contact__c=c.Id);
        System.runAs(portalAccountOwner) {
        insert uc;
        }
        
        // Get UserCertification
        redwing__User_Certification__c uc1 = [SELECT Id, Contact__c, redwing__User__c FROM redwing__User_Certification__c WHERE Id=:uc.Id LIMIT 1];
        System.assertEquals(uc1.redwing__User__c, portalUser.Id);
    }
    
    // Test UserCertification Before Insert, Before Update
    // Scenario: UserCertification is created, with user, no contact included
    // Scenario2: UserCertification is updated, with user, user doesn't have contact
    static testMethod void createUserCertification_createUpdate_withUser() {
        // Get Contact, create UserCertification
        User portalAccountOwner = [SELECT Id FROM User WHERE Email='test22222@testingARC.com' LIMIT 1];
        User portalUser = [SELECT Id FROM User WHERE Email='test11111@testingARC.com' LIMIT 1];
        Contact c = [SELECT Id FROM Contact WHERE FirstName='First11 0' LIMIT 1];

        redwing__User_Certification__c uc = new redwing__User_Certification__c(redwing__User__c=portalUser.Id);
        System.runAs(portalAccountOwner) {
        insert uc;
        }
        
        // Get UserCertification and update Contact field
        redwing__User_Certification__c uc1 = [SELECT Id, Contact__c, redwing__User__c FROM redwing__User_Certification__c WHERE Id=:uc.Id LIMIT 1];
        System.assertEquals(uc1.Contact__c,c.Id);
        uc1.redwing__User__c = portalAccountOwner.Id;
        System.runAs(portalAccountOwner) {
        update uc1;
        }
        redwing__User_Certification__c uc2 = [SELECT Id, Contact__c, redwing__User__c FROM redwing__User_Certification__c WHERE Id=:uc.Id LIMIT 1];
        System.assertEquals(uc2.Contact__c, null);
    }
       
}