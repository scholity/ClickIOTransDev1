/**
 * Created by dgajwani on 9/22/18.
 */

public with sharing class cc_lx_ProductListComponentController {

    /**
     * @description Searches and returns products matching the searchString.
     *
     * @param searchString
     *
     * @return
     */
    @AuraEnabled
    public static Map<String, Object> searchProducts(String searchString){
        Map<String, Object> searchResult;
        try {
            searchResult = cc_lx_ProductUtil.productSearch(searchString);
        } catch (Exception e) {
            searchResult = cc_lx_Exception.getErrorMessageMap(e.getMessage());
        }
        return searchResult;
    }

    /**
     * @description Adds the products to the specified cart. If the encrypted cart ID is null, a new cart is created.
     *
     * @param productQuantityMap
     * @param encryptedCartId
     *
     * @return
     */
    @AuraEnabled
    public static Map<String, Object> addToCart(Map<String, Object> productQuantityMap, String encryptedCartId){
        Map<String, Object> addToCartResult;
        try {
            addToCartResult = cc_lx_CartUtil.addProductsToCart(productQuantityMap, encryptedCartId);
        } catch (Exception e) {
            addToCartResult = cc_lx_Exception.getErrorMessageMap(e.getMessage());
        }
        return addToCartResult;
    }

}