/**
 * Created by dgajwani on 9/22/18.
 */

public with sharing class cc_lx_CartUtil {

    private static final String PRODUCT_SFID_KEY = 'sfid';

    private static final String CART_ITEMS_KEY = 'ECartItemsS';
    private static final String CART_ITEMS_PRODUCTDETAILS = 'productR';
    private static final String CART_ITEMS_QUANTITY_KEY = 'originalQuantity';
    private static final String CART_PRODUCT_QUANTITY_MAP_KEY = 'productQuantityMap';
    private static final String CART_ENCRYPTED_ID_KEY = 'encryptedCartId';

    private static final String FAILED_TO_CREATE_LINE_ITEMS = 'Failed to create line items.';
    private static final String FAILED_TO_ADD_ITEMS_TO_CART = 'Failed to add items to the cart.';
    private static final String FAILED_TO_REMOVE_ITEMS_TO_CART = 'Failed to remove items to the cart.';
    private static final String FAILED_TO_CREATE_PRODUCT_QUANTITY_MAP = 'Failed to create Product Quantities Map.';
    private static final String FAILED_TO_CREATE_CART = 'Failed to create a Cart.';
    private static final String FAILED_TO_PROCESS_PAYMENT_DATA = 'Failed to process payment data.';

    /**
     * @description Creates line items from the productQuanityMap
     * @param productQuantityMap
     * @return
     */
    public static List<Map<String, Object>> createLineItems(Map<String, Object> productQuantityMap) {
        try {
            List<Map<String, Object>> lineData = new List<Map<String, Object>>();

            for (String sfid : productQuantityMap.keySet()) {
                Map<String, Object> lineDataItem = new Map<String, Object>();

                if (Integer.valueOf(productQuantityMap.get(sfid)) > 0) {
                    lineDataItem.put(ccrz.ccApiCart.LINE_DATA_QUANTITY, Integer.valueOf(productQuantityMap.get(sfid)));
                    lineDataItem.put(ccrz.ccApiCart.LINE_DATA_PRODUCT_SFID, sfid);
                    lineData.add(lineDataItem);
                }
            }
            return lineData;
        } catch (Exception e) {
            throw new cc_lx_Exception(FAILED_TO_CREATE_LINE_ITEMS);
        }
    }

    /**
     * @description Adds the line data to the CC Cart. If encryptedCartId is blank, a new cart is first created.
     *
     * @param productQuantityMap
     * @param encryptedCartId
     *
     * @return
     */
    public static Map<String, Object> cartAddTo(List<Map<String, Object>> lineData, String encryptedCartId) {
        try {

            Map<String, Object> inputData = new Map<String, Object>{
                    ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                    ccrz.ccApiCart.LINE_DATA => lineData,
                    ccrz.ccAPI.SIZING => new Map<String, Object>{
                            ccrz.ccAPICart.ENTITYNAME => new Map<String, Object>{
                                    ccrz.ccAPI.SZ_REFETCH => true,
                                    ccrz.ccAPI.SZ_DATA => ccrz.ccAPI.SZ_L
                            }
                    }
            };

            if (!String.isEmpty(encryptedCartId)) {
                inputData.put(ccrz.ccApiCart.CART_ENCID, encryptedCartId);
            }

            return ccrz.ccApiCart.addTo(inputData);
        } catch (Exception e) {
            throw new cc_lx_Exception(FAILED_TO_ADD_ITEMS_TO_CART);
        }
    }

    /**
     * @description Removes lineData items from the cart.
     *
     * @param productQuantityMap
     * @param encryptedCartId
     *
     * @return
     */
    public static Map<String, Object> cartRemoveFrom(List<Map<String, Object>> lineData, String encryptedCartId) {
        try {

            Map<String, Object> inputData = new Map<String, Object>{
                    ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                    ccrz.ccApiCart.CART_ENCID => encryptedCartId,
                    ccrz.ccApiCart.LINE_DATA => lineData,
                    ccrz.ccAPI.SIZING => new Map<String, Object>{
                            ccrz.ccAPICart.ENTITYNAME => new Map<String, Object>{
                                    ccrz.ccAPI.SZ_REFETCH => true,
                                    ccrz.ccAPI.SZ_DATA => ccrz.ccAPI.SZ_L
                            }
                    }
            };

            return ccrz.ccApiCart.removeFrom(inputData);
        } catch (Exception e) {
            throw new cc_lx_Exception(FAILED_TO_REMOVE_ITEMS_TO_CART);
        }
    }

    /**
     * @description Create a Map<String,Object> of product quanities keyed to product sfid.
     *
     * @return Map<String,Object> Containing Product SFID and associated quantity on cart.
     */
    public static Map<String, Object> getProductQuantitiesMapFromCart(Map<String, Object> currCart) {
        try {
            Map<String, Object> productQuantityMap = new Map<String, Object>();

            List<Map<String, Object>> cartItems = (List<Map<String, Object>>) currCart.get(CART_ITEMS_KEY);

            for (Map<String, Object> cartItem : cartItems) {
                Map<String, Object> productDetails = (Map<String, Object>) cartItem.get(CART_ITEMS_PRODUCTDETAILS);
                productQuantityMap.put((String) productDetails.get(PRODUCT_SFID_KEY), cartItem.get(CART_ITEMS_QUANTITY_KEY));
            }

            return productQuantityMap;
        } catch (Exception e) {
            throw new cc_lx_Exception(FAILED_TO_CREATE_PRODUCT_QUANTITY_MAP);

        }
    }

    /**
     * @description Creates a CC Cart and returns the added cart items.
     *
     * @return
     */
    public static Map<String, Object> addProductsToCart(Map<String, Object> productQuantityMap, String encryptedCartId) {
        try {
            List<Map<String, Object>> lineData = createLineItems(productQuantityMap);
            Map<String, Object> addToResult = cartAddTo(lineData, encryptedCartId);

            String cartEncryptedId = (String) addToResult.get(ccrz.ccAPICart.CART_ENCID);
            return new Map<String, Object>{
                    CART_ENCRYPTED_ID_KEY => cartEncryptedId
            };
        } catch (Exception e) {
            throw new cc_lx_Exception(FAILED_TO_CREATE_CART);
        }
    }

    /**
     * @description Creates a CC TransactionPayment Record to store the payment details.
     *
     * @return
     */
    public static Map<String, Object> processPayment(ccrz__E_Cart__c cart, String paymentData) {
        try {

            Map<String, Object> paymentRequest = new Map<String, Object>{
                    ccrz.cc_hk_Payment.PARAM_TRANSACTION_DATA => paymentData,
                    ccrz.cc_hk_Payment.PARAM_CART => cart,
                    ccrz.cc_hk_Payment.PARAM_PAYMENT_CTX => ccrz.cc_hk_Payment.PARAM_PAYMENT_CTX_CHECKOUT
            };
            //TODO: Do we need this method? ccApiCart.place() should take care of this.
            ccrz.cc_hk_Payment paymentHook = ccrz.cc_hk_Payment.getInstance(null);
            return paymentHook.processPayment(paymentRequest);
        } catch (Exception e) {
            throw new cc_lx_Exception(FAILED_TO_PROCESS_PAYMENT_DATA);
        }
    }

    /**
     * @description Converts the cart into an Order.
     *
     * @return
     */
    public static Map<String, Object> placeOrder(ccrz__E_Cart__c cart, String paymentData) {
        try {

            Map<String, Object> paymentResult = processPayment(cart, paymentData);
            Map<String, Object> transactionPaymentData = (Map<String, Object>) paymentResult.get(ccrz.cc_hk_Payment.PARAM_TRANSACTION_PROCESSED_DATA);

            Map<String, Object> placeOrderRequest = new Map<String, Object>{
                    ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                    ccrz.ccApiCart.CART_ENCID => cart.ccrz__EncryptedId__c,
                    ccrz.ccApiCart.SKIP_VALID_CHECK => true,
                    ccrz.ccApiCart.PAYMENTDATA => paymentData,
                    ccrz.ccApiCart.TRANSPAYMENTDATA => transactionPaymentData,
                    ccrz.ccApiCart.PAYMENTRESULT => paymentResult
            };

            return ccrz.ccApiCart.place(placeOrderRequest);
        } catch (Exception e) {
            throw new cc_lx_Exception(FAILED_TO_PROCESS_PAYMENT_DATA);
        }
    }


}