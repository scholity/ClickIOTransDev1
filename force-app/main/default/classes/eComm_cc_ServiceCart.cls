global with sharing class eComm_cc_ServiceCart extends ccrz.ccServiceCart{
   
    global virtual override Map<String, Object> getFilterMap(Map<String, Object> inputData) {
        system.debug('in custom filter map');
        ccrz.ccLog.log(System.LoggingLevel.INFO, 'in custom filter map');
        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ccrz.ccAPICart.CART_ID ' + ccrz.ccAPICart.CART_ID);
        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ccrz.ccAPICart.CART_ENCID ' + ccrz.ccAPICart.CART_ENCID);
        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ccrz.ccAPICart.CARTTYPE ' + ccrz.ccAPICart.CARTTYPE);
        Map<String, Object> localizedFilterMap1 = new Map<String, Object>( eComm_cc_ServiceCart.FILTERMAP1);
        Map<String, Object> localizedFilterMap2 = new Map<String, Object>( eComm_cc_ServiceCart.FILTERMAP2);
         
        if (inputData.get(ccrz.ccApiCart.CART_ID) != null) { // If cartId, then drop the singular query from the map.
            localizedFilterMap1.remove(ccrz.ccApiCart.CART_ENCID);
            localizedFilterMap2.remove(ccrz.ccApiCart.CART_ENCID);
        }else if (inputData.get(ccrz.ccApiCart.CART_ENCID) != null) { // If a list, then drop the singular query from the map.
            localizedFilterMap1.remove(ccrz.ccApiCart.CART_ID);
            localizedFilterMap2.remove(ccrz.ccApiCart.CART_ID);
        }else{
            localizedFilterMap1.remove(ccrz.ccApiCart.CART_ENCID);
            localizedFilterMap1.remove(ccrz.ccApiCart.CART_ID);
            localizedFilterMap2.remove(ccrz.ccApiCart.CART_ENCID);
            localizedFilterMap2.remove(ccrz.ccApiCart.CART_ID);
        }
         
        if (inputData.get(ccrz.ccApiCart.BYSTOREFRONT) == null) {
            localizedFilterMap1.remove(ccrz.ccApiCart.BYSTOREFRONT);
            localizedFilterMap2.remove(ccrz.ccApiCart.BYSTOREFRONT);
        }
        /*
        if (inputData.get(ccAPICart.BYOWNER) == null) {
            localizedFilterMap.remove(ccApiCart.BYOWNER); 
        }
        */
          
        if (inputData.get(ccrz.ccAPICart.CARTSTATUS) == null) {
            localizedFilterMap1.remove(ccrz.ccApiCart.CARTSTATUS);  
            localizedFilterMap2.remove(ccrz.ccApiCart.CARTSTATUS);
        }
        if (inputData.get(ccrz.ccAPICart.CARTTYPE) == null) {
            localizedFilterMap1.remove(ccrz.ccApiCart.CARTTYPE);
            localizedFilterMap2.remove(ccrz.ccApiCart.CARTTYPE);
        }
         
        if (inputData.get(ccrz.ccApiCart.CART_ID) == null && inputData.get(ccrz.ccApiCart.CART_ENCID) == null){
            system.debug('localizedFilterMap2-->'+localizedFilterMap2);
            return localizedFilterMap2;
        }else{
            system.debug('localizedFilterMap1-->'+localizedFilterMap1);
            return localizedFilterMap1;
        }
         
         
    }
     
 
    private static final Map<String, Object> FILTERMAP1 = new Map<String, Object>{   
        ccrz.ccAPICart.CART_ID => ' Id = :' + ccrz.ccAPICart.CART_ID + ' ',
        ccrz.ccAPICart.CART_ENCID => ' EncryptedId__c = :' + ccrz.ccAPICart.CART_ENCID + ' ',
        'isDeleted' => 'AND IsDeleted = false ',
        ccrz.ccAPICart.CARTTYPE => ' AND CartType__c = :' + ccrz.ccAPICart.CARTTYPE, // TODO - handle wishlist carts as well.
        ccrz.ccAPICart.BYSTOREFRONT => ' AND Storefront__c =:' + ccrz.ccAPICart.BYSTOREFRONT,
        //ccAPICart.BYOWNER => ' AND OwnerId =:' + ccAPICart.BYOWNER,
        ccrz.ccAPICart.CARTSTATUS => ' AND CartStatus__c = :' + ccrz.ccAPICart.CARTSTATUS
    };
         
    private static final Map<String, Object> FILTERMAP2 = new Map<String, Object>{   
        ccrz.ccAPICart.CART_ID => ' Id = :' + ccrz.ccAPICart.CART_ID + ' ',
        ccrz.ccAPICart.CART_ENCID => ' EncryptedId__c in :' + ccrz.ccAPICart.CART_ENCID + ' ',
        'isDeleted' => ' IsDeleted = false ',
        //'isDeleted' => ' AND IsDeleted = false ',
        ccrz.ccAPICart.CARTTYPE => ' AND CartType__c = :' + ccrz.ccAPICart.CARTTYPE, // TODO - handle wishlist carts as well.
        ccrz.ccAPICart.BYSTOREFRONT => ' AND Storefront__c =:' + ccrz.ccAPICart.BYSTOREFRONT,
        //ccAPICart.BYOWNER => ' AND OwnerId =:' + ccAPICart.BYOWNER,
        ccrz.ccAPICart.CARTSTATUS => ' AND CartStatus__c = :' + ccrz.ccAPICart.CARTSTATUS
    };
   
  }