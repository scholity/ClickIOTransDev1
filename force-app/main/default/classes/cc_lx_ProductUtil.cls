/**
 * Created by dgajwani on 9/22/18.
 */

public with sharing class cc_lx_ProductUtil {

    private static final String PRODUCT_SFID_KEY = 'sfid';

    private static final String FAILED_TO_PERFORM_SEARCH_REQUEST = 'Failed to perform search request.';
    private static final String FAILED_TO_GET_PRODUCT_DETAILS = 'Failed to get Product Details.';
    private static final String FAILED_TO_PERFORM_SEARCH = 'Failed to perform search.';
    private static final String FAILED_TO_CREATE_A_PRODUCT_MAP = 'Failed to create a product map.';
    private static final String ERROR_MSG_NO_PRODUCTS_FOUND = 'No Products found.';

    /**
     * @description Performs a search to return all products matching the query string.
     *
     * @param query
     */
    public static Set<String> doSearch(String searchString) {
        Set<String> searchResults;
        try {
            Map<String, Object> request = new Map<String, Object>{
                    ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                    ccrz.ccService.SEARCHSTRING => searchString
            };
            Map<String, Object> response = ccrz.ccAPIProduct.search(request);
            Boolean isSuccess = (Boolean) response.get(ccrz.ccAPI.SUCCESS);
            if (isSuccess) {
                searchResults = (Set<String>) response.get(ccrz.ccService.SEARCHRESULTS);
            }
        } catch (Exception e) {
            throw new cc_lx_Exception(FAILED_TO_PERFORM_SEARCH_REQUEST);
        }
        return searchResults;
    }

    /**
     * @description Performs a ccApiProduct.fetch on each of the product IDs to get relevant details.
     *
     * @param productSfids
     *
     * @return
     */
    public static List<Map<String, Object>> getProductDetails(Set<String> productIds) {
        List<Map<String, Object>> productDataList;
        try {
            Map<String, Object> request = new Map<String, Object>{
                    ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                    ccrz.ccApiProduct.PARAM_INCLUDE_PRICING => true,
                    ccrz.ccAPIProduct.PRODUCTIDLIST => productIds
            };

            Map<String, Object> response = ccrz.ccAPIProduct.fetch(request);
            Boolean isSuccess = (Boolean) response.get(ccrz.ccAPI.SUCCESS);
            if (isSuccess) {
                productDataList = (List<Map<String, Object>>) response.get(ccrz.ccAPIProduct.PRODUCTLIST);
            }
        } catch (Exception e) {
            throw new cc_lx_Exception(FAILED_TO_GET_PRODUCT_DETAILS);
        }
        return productDataList;
    }

    /**
     * @description Creates a map of SFID->ProductDetails. This is done for easy rendering in Lightning component.
     *
     * @param productData
     *
     * @return
     */
    public static Map<String, Object> getProductMapKeyedToSfidMap(List<Map<String, Object>> productData) {
        Map<String, Object> productsById;
        try {
            productsById = new Map<String, Object>();
            for (Object obj : productData) {
                Map<String, Object> currProduct = (Map<String, Object>) obj;
                String productSfid = (String) currProduct.get(PRODUCT_SFID_KEY);
                productsById.put(productSfid, currProduct);
            }
        } catch (Exception e) {
            throw new cc_lx_Exception(FAILED_TO_CREATE_A_PRODUCT_MAP);
        }
        return productsById;
    }


    /**
     * @description Returns a Map of product Details of all products matching the query string.
     *
     * @param query
     *
     * @return
     */
    public static Map<String, Object> productSearch(String searchString) {
        Map<String, Object> searchResponse;
        List<Map<String, Object>> productData = new List<Map<String, Object>>();
        Map<String, Object> productMap = new Map<String, Object> ();

        try {
            Set<String> productIds = doSearch(searchString);
            if (productIds.size() > 0) {
                productData = getProductDetails(productIds);
                productMap = getProductMapKeyedToSfidMap(productData);
            }
        } catch (Exception e) {
            throw new cc_lx_Exception(FAILED_TO_PERFORM_SEARCH);
        }
        searchResponse = new Map<String, Object>{
                'productList' => productMap.keySet(),
                'productMap' => productMap
        };
        return searchResponse;
    }
}