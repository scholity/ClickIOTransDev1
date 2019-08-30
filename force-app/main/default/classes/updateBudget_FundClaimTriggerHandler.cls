/*
 * Auther : Salesforce Services
     * Recalculates The FundClaim Amount on the Budget on insert, update, delete of a fund claim.
     * Only those FundClaims are considered which are approved (approved__c = true)
     *
     */ 
public class updateBudget_FundClaimTriggerHandler {
    public updateBudget_FundClaimTriggerHandler(){}
    public void updateBudget_FundClaim(list<SFDC_MDF_Claim__c> newSFDCMDFClaims,list<SFDC_MDF_Claim__c> oldSFDCMDFClaims, boolean isInsert, boolean isUpdate, boolean isDelete, boolean isUndelete){
        List<SFDC_Budget__c> budgetList = new List<SFDC_Budget__c>();
    Set<Id> budgetSet = new Set<Id>();
    
    if (isDelete) {
        //for delete
        for (SFDC_MDF_Claim__c changedMDFClaim : oldSFDCMDFClaims) {
            if (changedMDFClaim.Budget__c != null)
                budgetSet.add(changedMDFClaim.Budget__c);
        }
        
    } else {
        if (isUpdate) {
            for (Integer i = 0; i < newSFDCMDFClaims.size(); i++) { 
                SFDC_MDF_Claim__c oldMDFClaim = oldSFDCMDFClaims[i];
                SFDC_MDF_Claim__c newMDFClaim = newSFDCMDFClaims[i];
                Id oldBudgetId = oldMDFClaim.Budget__c;
                Id newBudgetId = newMDFClaim.Budget__c;
                if (oldBudgetId != null) {
                    if (newBudgetId == null || oldBudgetId != newBudgetId) {
                    	//budget removed - need to update old budget
                    	budgetSet.add(oldBudgetId);
                    }
                }   
            }
        }
        
        for (SFDC_MDF_Claim__c changedMDFClaim : newSFDCMDFClaims) {
            if (changedMDFClaim.Budget__c != null)
                budgetSet.add(changedMDFClaim.Budget__c);
        }
    }
    budgetList = BudgetUtil.getBudgetListForFundClaim(budgetSet);

    //update the budget objects
    if (budgetList.size() > 0) {
        try {
           BudgetUtil.updateList(budgetList);
        } catch (DmlException e) {
            String message = 'An error occured while Updating Budget: ';
            message += '\nMessage: ' + e.getMessage();
            message += '\nCause: ' + e.getCause();
            System.debug(message);
            budgetList.get(0).addError(message);
        }
    }
    }

}