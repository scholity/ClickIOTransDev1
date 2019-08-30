/************************************************************************************************************************************
** Author: Salesforce Services
** Description: Update the Partner Owner field when the record is owned by a partner
************************************************************************************************************************************/
public class updateFundClaimChannelManagerHandler {
    public updateFundClaimChannelManagerHandler(){}
    public void updateFundClaimChannelManager(list<SFDC_MDF_Claim__c> newFundClaims, boolean isInsert, boolean isUpdate){
        Set<Id> ownerIds = new Set<Id>();
        set<Id> FundRequestIds = new set<Id>();
        
        //Loop through each fund claim and create a Set of all the UserIds for the fund claim owners 
        for (SFDC_MDF_Claim__c fundClaim : newFundClaims) {
            //Figure out the owner ids of the fund claims 
            ownerIds.add(fundClaim.OwnerId);
            //Figure out the owner ids of the fund requests
            FundRequestIds.add(fundClaim.Fund_Request__c);
        }
        map<id,SFDC_MDF__c> mapFundRequestToClaim  = new map<id,SFDC_MDF__c>();
        //put the fund requests into a map to match the claim budget to fund request budget
        if(isInsert){
            if(!FundRequestIds.isEmpty()){
                for(SFDC_MDF__c MDF : [Select Budget__c From SFDC_MDF__c where Id IN : FundRequestIds]){
                	mapFundRequestToClaim.put(MDF.id,MDF);    
                }
            }    
        }
        //Create a map of the owernids to their partner accounts
        Map<Id,User> partnerAccts = new Map<Id,User>([Select Id, Contact.Account.OwnerId,Contact.Account.Id from User where id in :ownerIds]);
        
        //Now loop through each fund claim to set the Partner Account Id on the claim
        for (SFDC_MDF_Claim__c fundClaim : newFundClaims) {
            //Update the partner account manager 
            if ((partnerAccts.get(fundClaim.OwnerId).Contact.Account.OwnerId != NULL) && (fundClaim.Partner_Owner__c == NULL)) {
                fundClaim.Partner_Owner__c = partnerAccts.get(fundClaim.OwnerId).Contact.Account.OwnerId;
            }
            if ((partnerAccts.get(fundClaim.OwnerId).Contact.Account.Id != NULL) && (fundClaim.account__c == NULL)) {
            	fundClaim.account__c = partnerAccts.get(fundClaim.OwnerId).Contact.Account.Id;
        	}
            //Assign Fund request budget to claim budget and it can assigned only at the time of insert
            if(isInsert){
                if(mapFundRequestToClaim.containsKey(fundClaim.Fund_Request__c)) {
                    if (mapFundRequestToClaim.get(fundClaim.Fund_Request__c).Budget__c != null) {
                        fundClaim.Budget__c = mapFundRequestToClaim.get(fundClaim.Fund_Request__c).Budget__c;
                    }
                }   
            }
        }    
    }
    
     /*
     * Recalculates The FundClaim Amount on the Budget on insert, update, delete of a fund claim.
     * Only those FundClaims are considered which are approved (approved__c = true)
     *
     */ 
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