@isTest
public class AccountAffiliationControllerTest
{
  @IsTest(seeAllData=false)
   public static void testmethod1()
    {
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bucket Account').getRecordTypeId();
        
        //Bucket Custom settings
        Bucket_Account_Settings__c bas = Bucket_Account_Settings__c.getOrgDefaults();
        bas.Bucket_Account_Owner_ID__c = UserInfo.getUserID();
        bas.Bucket_Account_RecordTypeID__c = recordTypeId;
        bas.Default_Bucket_Name__c = 'Bucket Account';
        bas.Maximum_Size_of_Bucket__c = 5000;
        insert bas;
        
        // User Credentials:
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'SB PHSS-Partner-Community Plus Login' LIMIT 1];
        
        Account accRecord = new account();
        accRecord.Name = 'Test Acc123';
        insert accRecord;
        
        Contact conRecord = new Contact();
        conRecord.LastName = 'Munn';
        conRecord.FirstName = 'Paul';
        conRecord.Email = 'Paulmunn@gmail.com';
        conRecord.Account = accRecord;
        insert conRecord;
        
        User u1 = new User(Alias = 'newUser', Email='newuser@testorg.com',
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                           LocaleSidKey='en_US', ProfileId = profileId.Id,ContactId = conRecord.Id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg.com');
        insert u1;
        
        AccountContactRelation accConRel = new AccountContactRelation();
        accConRel.contactId = conRecord.Id;
        accConRel.accountId = accRecord.Id;
        string values = 'Instructor;Administrator';
        accConRel.Roles = values;
        insert accConRel;

        System.runAs(u1)
        {
            Test.startTest();
            AccountAffiliationController.getAccountContactDetails();
          //  AccountAffiliationController.removeAccountContactDetails('value');
            Test.stopTest();
        }
    }
}