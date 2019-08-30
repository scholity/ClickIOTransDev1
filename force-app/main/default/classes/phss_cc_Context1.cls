public without sharing class phss_cc_Context1 {

    private static final String INIT_CONTEXT_ERROR_MSG = 'Failed to instantiate context.';

    /**
     * @description CC Storefront being used.
     */
    public static String STOREFRONT_NAME {
        get {
            return 'GeneralStore';
        }
        private set;
    }

    /**
     * @description Current Opportunity Id.
     */
    public static String currOpportunityId {
        get {
            return currOpportunityId;
        }
        private set;
    }

    /**
     * @description Current Account Id.
     */
    public static String currAccountId {
        get {
            if (null == currAccountId) {
                Opportunity currOpportunity = [
                        SELECT Id,AccountId
                        FROM Opportunity
                        WHERE Id = :currOpportunityId
                        LIMIT 1
                ];
                currAccountId = currOpportunity.AccountId;
            }
            return currAccountId;
        }
        private set;
    }

    /**
     * @description Current Cart object Id.
     */
    public static ccrz__E_Cart__c currCart {
        get {
            if (null == currCart) {
                List<ccrz__E_Cart__c> fetchCarts = [
                        SELECT Id,ccrz__Account__c, ccrz__EncryptedId__c
                        FROM ccrz__E_Cart__c
                        WHERE Opportunity__c = :currOpportunityId AND ccrz__ActiveCart__c = true
                        LIMIT 1
                ];
                if (!fetchCarts.isEmpty()){
                    currCart = fetchCarts[0];
                }
            }
            return currCart;
        }
        private set;
    }

    /**
     * @description Get the priceGroupId if there is one.
     */
    public static String currPriceGroupId {
        get {
            if (null == currPriceGroupId) 
            {
                currPriceGroupId = phss_cc_OrderUtil.fetchPriceGroupIdByAccount(currAccountId,STOREFRONT_NAME);
            }
            return currPriceGroupId;
        }
        private set;
    }

    /**
     * @description Sets current commerce context for LEX components.
     *
     * @param ctx Serialized JSON representing ccrz.cc_RemoteActionContext.
     */
    public static void setContext(String opportunitySfid) {
        try {
            currOpportunityId = opportunitySfid;

            ccrz.cc_RemoteActionContext remoteActionContext = new ccrz.cc_RemoteActionContext();
            remoteActionContext.storefront = STOREFRONT_NAME;

            if (currPriceGroupId != '') {
                remoteActionContext.priceGroupId = currPriceGroupId;
            }
            ccrz.cc_CallContext.init(remoteActionContext);

        } catch (Exception e) {
            throw new phss_cc_Exception(INIT_CONTEXT_ERROR_MSG);
        }
    }
}