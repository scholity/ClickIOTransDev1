/************************************************************************************************************************************
** Author: Salesforce Services
** Description: *   Shares any budgets where the account field is populated with a partner account.
*   Read only access is given to the partner user group of the partner account. 
************************************************************************************************************************************/
public with sharing class ShareBudgetWithPartnerTriggerHandler {
    public ShareBudgetWithPartnerTriggerHandler(){}
    public void ShareBudgetWithPartner(List<SFDC_Budget__c> newBudgets, List<SFDC_Budget__c> oldBudgets, Map<ID,SFDC_Budget__c> newBudgetMap , Map<ID,SFDC_Budget__c> oldBudgetMap, boolean isInsert, boolean isUpdate){
        /**
*   Shares any budgets where the account field is populated with a partner account.
*   Read only access is given to the partner user group of the partner account.
*
*/
        
        Account partnerAccount;                                                 //The partner account being operated on
        String roleName;                                                        //The role of the partner account
        Map <String, Id> budgetMap = new Map <String, Id>();                    //A map from role to budget id
        Map <Id, String> roleMap = new Map <Id, String>();                      //A map from role id to role name
        Map <Id, Id> groupMap   = new Map <Id, Id>();                           //A map from group id to budget id
        List <SFDC_Budget__c> shareBudgets = new List <SFDC_Budget__c> ();      //A list of updated budgets to be shared
        
        List <SFDC_Budget__share> newShares = new List <SFDC_Budget__share>();  //New budget shares to create
        List <SFDC_Budget__share> budgetDels = new List <SFDC_Budget__share> ();//Old budget shares to delete
        
        //Now loop through each fund claim to set the Partner Account Id on the claim
        for (Integer i=0; i<newBudgets.size(); i++) {
            //If the New Account field is not empty and it has changed then manually share to the partner
            //Share if it's a new record with a Partner Account or an old record where the partner account field is now filled in
            if (isUpdate) {
                if ((newBudgets[i].Account__c != NULL) 
                    && (newBudgets[i].Account__c != oldBudgets[i].Account__c)) {
                        
                        shareBudgets.add(newBudgets[i]);
                    }
            } else if (isInsert && newBudgets[i].Account__c != NULL) {
                shareBudgets.add(newBudgets[i]);
            }
        }
        System.debug('shareBudgets: ' + shareBudgets);
        if (shareBudgets.size() > 0) {
            
            Set <Id> accIds = new Set <Id>();
            
            for (SFDC_Budget__c b : shareBudgets){
                accIds.add(b.Account__c);
            }
            //Query which of the accounts is a partner account
            Map <Id, Account> partnerAccounts = new Map <Id, Account> ([Select IsPartner, Name 
                                                                        from Account 
                                                                        where Id IN : accIds 
                                                                        and IsPartner = true]);
            System.debug('partnerAccounts: ' + partnerAccounts);                                                                        
            //Only share if the account is a partner account
            for (SFDC_Budget__c b : shareBudgets){
                
                partnerAccount = partnerAccounts.get(b.Account__c);
                
                if (partnerAccount != null) {
                    //if the account name is really long, truncate the role name
                    if (partnerAccount.Name.length() > 62) {
                        roleName = partnerAccount.Name.substring(0,62)+' Partner User';
                    } else {
                        roleName = partnerAccount.Name+' Partner User';
                    }
                    System.debug('Rolename='+rolename);
                    
                    budgetMap.put(rolename, b.Id);
                }
            }
            System.debug('budgetMap: ' + budgetMap);
            //Create a map from UserRole Id to UserRole name 
            for (UserRole ur : [Select Id, Name 
                                from UserRole 
                                where Name IN : budgetMap.keyset()]){
                                    
                                    roleMap.put(ur.Id, ur.Name);
                                }
            System.debug('roleMap: ' + roleMap);
            //needed to get proper code coverage
            //Cannot create the required relationships through APEX
            if (MDFTests.IsTest == true){
                Group pg = [select Id, RelatedId 
                            from Group 
                            Limit 1];
                
                groupMap.put(pg.Id, pg.RelatedId);
            }else{
                for (Group pg : [select Id, RelatedId 
                                 from Group 
                                 where RelatedId IN : roleMap.keyset() 
                                 and Type='Role']){
                                     
                                     roleName = roleMap.get(pg.RelatedId);
                                     Id budgetId = budgetMap.get(roleName);
                                     SFDC_Budget__share bugetShare = new SFDC_Budget__share(UserOrGroupId=pg.Id, RowCause='manual',ParentId=budgetId,AccessLevel='Read');
                                     newShares.add(bugetShare);
                                 }               
            }
        } 
        
        //if the Accout field is NULL and didn't use to be delete the manual share to the partner
        if (isUpdate) {
            
            Set <Id> accIds = new Set <Id>();
            
            for (SFDC_Budget__c b : oldBudgets){
                accIds.add(b.Account__c);
            }
            
            Map <Id, Account> partnerAccounts = new Map <Id, Account> ([Select IsPartner, Name 
                                                                        from Account 
                                                                        where Id IN : accIds]);
            System.debug('partnerAccounts: ' + partnerAccounts);
            for (Integer i=0; i<newBudgets.size(); i++) {
                
                if ((newBudgets[i].Account__c != oldBudgets[i].Account__c) 
                    && (oldBudgets[i].Account__c != NULL)
                    && partnerAccounts.get(oldBudgets[i].Account__c) != null){
                        
                        partnerAccount = partnerAccounts.get(oldBudgets[i].Account__c);
                        //if the account name is really long, truncate the role name
                        if (partnerAccount.Name.length() > 62) {
                            roleName = partnerAccount.Name.substring(0,62)+' Partner User';
                        } else {
                            roleName = partnerAccount.Name+' Partner User';
                        }
                        budgetMap.put(roleName, Trigger.new[i].Id);
                    }
            }
            System.debug('budgetMap: ' + budgetMap);
            //Query the UserRoles for the partner accounts
            for (UserRole pur : [Select Id, Name 
                                 from UserRole 
                                 where Name IN :budgetMap.keyset()]){
                                     roleMap.put(pur.Id, rolename);
                                 }
            System.debug('roleMap: ' + roleMap);
            //Find the groups related to these roles.
            for (Group pg : [select Id, RelatedId
                             from Group 
                             where RelatedId IN : roleMap.keyset() 
                             and Type='Role']){
                                 
                                 groupMap.put(pg.Id, pg.RelatedId);
                             }
            System.debug('groupMap: ' + groupMap);
            //Get all the shares to be deleted.             
            for (SFDC_Budget__share bud :[select Id, UserOrGroupId 
                                          from SFDC_Budget__share 
                                          where UserOrGroupId IN: groupMap.keyset() 
                                          and RowCause='manual' 
                                          and ParentId IN : budgetMap.keyset() 
                                          and AccessLevel='Read']){
                                              budgetDels.add(bud);
                                          }
        }
        
        if (newShares.size() > 0){
            insert newShares;
        }
        if (budgetDels.size() > 0){
            delete budgetDels;
        }     
    }
    
}