/**
 * Created by jbarker on 2019-06-21.
 */

public with sharing class phss_cc_OpportunityUtil {

    // Approval Levels
    @TestVisible private static final String NO_APPROVAL_NEEDED_LEVEL = 'No Approval Needed';

    // Approval Statuses
    @TestVisible private static final String APPROVED_STATUS = 'Approved';
    @TestVisible private static final String REJECTED_STATUS = 'Rejected';
    @TestVisible private static final String SUBMIT_FOR_APPROVAL_STATUS = 'Submit for Approval';

    // Approval States
    @TestVisible private static final String APPROVED_STATE = 'Approved';
    @TestVisible private static final String NO_APPROVAL_REQUIRED_STATE = 'No approval required';
    @TestVisible private static final String REQUIRES_APPROVAL_STATE = 'Requires approval';
    @TestVisible private static final String REJECTED_STATE = 'Rejected';

    // Error messages
    private static final String FAILED_TO_FETCH_OPPORTUNITY_BY_ID = 'Failed to fetch opportunity by ID.';
    private static final String FAILED_TO_GET_APPROVAL_STATUS = 'Failed to get approval status.';


    public static Opportunity fetchOpportunity(String opportunityId) {
        Opportunity opportunity = null;

        try {
            Id id = Id.valueOf(opportunityId);

            opportunity = [
                    SELECT
                            Account_Group__c,
                            Account_Owner__c,
                            AccountId,
                            Amount,
                            Approval_Status__c,
                            CampaignId,
                            Cart_Id__c,
                            Case__c,
                            CC_Account_Group__c,
                            Closed_Lost_Details__c,
                            Closed_Lost_Reason__c,
                            Closed_Lost_Reason_New__c,
                            Closed_Won_Date__c,
                            CloseDate,
                            Confirmation_Number__c,
                            ContactId,
                            Contract_Exception__c,
                            Contract_Opportunity__c,
                            ContractId,
                            County__c,
                            Coupon_Code__c,
                            Course_ID__c,
                            Course_Name__c,
                            Created_From_Lead__c,
                            Customer_Contact__c,
                            Customer_Contact_email__c,
                            Customer_Contact_phone__c,
                            Customer_Contact_phone_ext__c,
                            Date_of_Sale__c,
                            Delta_Data_Migration__c,
                            Description,
                            DM_External_Id__c,
                            DM_Legacy_Owner_Name__c,
                            End_Date__c,
                            End_Time__c,
                            Equipment__c,
                            Equipment_Needed__c,
                            Est_Delivery_Fee__c,
                            Est_Num_of_Attendees__c,
                            Est_Price_per_Attendee__c,
                            Estimated_Annual_Enrollees__c,
                            ExpectedRevenue,
                            Final_Billing_Amount__c,
                            Fiscal,
                            FiscalQuarter,
                            FiscalYear,
                            ForecastCategory,
                            ForecastCategoryName,
                            FS_Transaction_Sale__c,
                            HasOpenActivity,
                            HasOpportunityLineItem,
                            HasOverdueTask,
                            Highest_Discount__c,
                            Highest_Product_Discount__c,
                            Highest_Product_Discount_Value__c,
                            Id,
                            IsClosed,
                            IsDeleted,
                            IsPrivate,
                            IsWon,
                            LeadSource,
                            LMS_Org_ID__c,
                            Name,
                            Pricebook2Id,
                            Pricing_Agreement__c,
                            Pricing_Approval_Level__c,
                            Pricing_Approval_Status__c,
                            Primary_Product__c,
                            Probability,
                            Processing_Notes__c,
                            RecordTypeId,
                            Saba_Order__c,
                            SCC_User__c,
                            Scheduling_Notes__c,
                            Source_System__c,
                            Special_Instructions__c,
                            StageName,
                            Start_Date__c,
                            Start_Time__c,
                            SyncedQuoteId,
                            TotalOpportunityQuantity,
                            Training_Contact__c,
                            Training_Contact_Cell_Phone__c,
                            Training_Contact_email__c,
                            Training_Contact_Office_Phone__c,
                            Training_Contact_Office_Title__c,
                            Training_Events_Created__c,
                            Training_Location__c,
                            Type,
                            Written_test__c
                    FROM
                            Opportunity
                    WHERE
                            Id = :id
            ];

        } catch (Exception e) {
            throw new phss_cc_Exception(FAILED_TO_FETCH_OPPORTUNITY_BY_ID, e);
        }

        return opportunity;
    }

    /**
     * @description Returns an approval state for a specific opportunity
     *
     * @param opportunityId
     *
     * @return
     */
    @AuraEnabled
    public static String getApprovalState(String opportunityId) {
        String state = REQUIRES_APPROVAL_STATE;
        try {
            Opportunity opportunity = [
                    SELECT Id, Approval_Status__c, Pricing_Approval_Level__c
                    FROM Opportunity
                    WHERE Id = :opportunityId
            ];

            if (opportunity != null) {
                if (opportunity.Pricing_Approval_Level__c == NO_APPROVAL_NEEDED_LEVEL) {
                    state = NO_APPROVAL_REQUIRED_STATE;

                } else if (opportunity.Approval_Status__c == APPROVED_STATUS) {
                    state = APPROVED_STATE;

                } else if (opportunity.Approval_Status__c == SUBMIT_FOR_APPROVAL_STATUS) {
                    state = REQUIRES_APPROVAL_STATE;

                } else if (opportunity.Approval_Status__c == REJECTED_STATUS) {
                    state = REJECTED_STATE;

                }
            }

        } catch (Exception e) {
            throw new phss_cc_Exception(FAILED_TO_GET_APPROVAL_STATUS, e);
        }

        return state;
    }
}