public with sharing class updateBudget_FundRequestTriggerHandler {
    public updateBudget_FundRequestTriggerHandler(){}
    public void updateBudget_FundRequest(list<SFDC_MDF__c> newSFDCMDFs, list<SFDC_MDF__c> oldSFDCMDFs, boolean isinsert, boolean isUpdate, boolean isDelete){
        List<SFDC_Budget__c> budgetList = new List<SFDC_Budget__c>();
        Set<Id> budgetSet = new Set<Id>();
        
        if (isDelete) {
            //for delete
            for (SFDC_MDF__c changedMDF : oldSFDCMDFs) {
                if (changedMDF.Budget__c != null) {
                    //budgetList.add(BudgetUtil.getUpdatedBudget(changedMDF));
                    budgetSet.add(changedMDF.Budget__c);
                }
            }
            
        } else {
            if (isUpdate) {
                for (Integer i = 0; i < newSFDCMDFs.size(); i++) {
                    SFDC_MDF__c oldMDF = oldSFDCMDFs[i];
                    SFDC_MDF__c newMDF = newSFDCMDFs[i];
                    Id oldBudgetId = oldMDF.Budget__c;
                    Id newBudgetId = newMDF.Budget__c;
                    System.debug(oldBudgetId);
                    if (oldBudgetId != null) {
                        if (newBudgetId == null || oldBudgetId != newBudgetId) {
                            //budget removed/changed - need to update old budget
                            budgetSet.add(oldBudgetId);
                        }
                    }   
                }
            }
            
            for (SFDC_MDF__c changedMDF : newSFDCMDFs) {
                if (changedMDF.Budget__c != null) {
                    budgetSet.add(changedMDF.Budget__c);
                }
            }
        }
        budgetList = BudgetUtil.getBudgetList(budgetSet);
        
        //update the budget objects
        if (budgetList.size() > 0) {
            try {
                BudgetUtil.updateList(budgetList);
            } catch (Exception e) {
                String message = 'An error occured while Updating Budget: ';
                message += '\nMessage: ' + e.getMessage();
                message += '\nCause: ' + e.getCause();
                System.debug(message);
                budgetList.get(0).addError(message);
            }
        }    
    }
    
    /**
*   Update the Partner Owner field when the record is owned by a partner
*
*/
    
    public void updateFundRequestChannelManager(list<SFDC_MDF__c> newMDFs){
        Set<Id> ownerIds = new Set<Id>();
        //Loop through each fund request and create a Set of all the UserIds for the fund request owners 
        for (SFDC_MDF__c fundRequest : newMDFs) {
            //Figure out the owner ids of the fund requests 
            ownerIds.add(fundRequest.OwnerId);
        }
        
        //Create a map of the owernids to their partner accounts
        Map<Id,User> partnerAccts = new Map<Id,User>([Select Id, Contact.Account.OwnerId,Contact.Account.Id from User where id in :ownerIds]);
        
        //Now loop through each fund request to set the Partner Account Id on the request
        for (SFDC_MDF__c fundRequest : newMDFs) {
            //Update the partner account manager 
            if ((partnerAccts.get(fundRequest.OwnerId).Contact.Account.OwnerId != NULL) && (fundRequest.Partner_Owner__c == NULL)) {
                fundRequest.Partner_Owner__c = partnerAccts.get(fundRequest.OwnerId).Contact.Account.OwnerId;
            }
             //Only update the value for records that have an owner = partnerAccount
             if ((partnerAccts.get(fundRequest.OwnerId).Contact.Account.Id != NULL) && (fundRequest.Account__c == NULL)) {
                fundRequest.Account__c = partnerAccts.get(fundRequest.OwnerId).Contact.Account.Id;
             }
        }    
    }
}