public without sharing class phss_cc_CartUtil1 {


    private static final String CART_ITEM_QUANTITY_KEY = 'quantity';
    private static final String CART_ITEM_PRICE_KEY = 'price';
    private static final String CART_ITEM_TYPE = 'cartItemType';
    private static final String CART_ITEM_TYPE_MAJOR = 'Major';
    private static final String CART_ITEM_TYPE_MINOR = 'Minor';
    private static final String CART_ITEM_SFID_KEY = 'sfid';
    private static final String CART_ITEM_PRODUCT_SFID_KEY = 'product';
    private static final String CART_ITEM_PARENT_CART_ITEM_KEY = 'parentCartItem';

    private static final String CART_ITEMS_KEY = 'ECartItemsS';
    private static final String CART_TOTAL_AMOUNT_KEY = 'totalAmount';
    private static final String PRODUCT_PRICE_KEY = 'price';
    private static final String MINOR_PRODUCT_QUANTITY_MAP_KEY = 'minorProductQuantityMap';
    private static final String MINOR_PRODUCT_LIST_KEY = 'minorProductList';


    @TestVisible private static final String CART_ENCRYPTED_ID_KEY = 'encryptedCartId';
    @TestVisible private static final String PRODUCT_LIST_KEY = 'productList';
    @TestVisible private static final String PRODUCT_MAP_KEY = 'productMap';
    @TestVisible private static final String PRODUCT_QUANTITY_MAP_KEY = 'productQuantityMap';
    @TestVisible private static final String CART_TOTAL_KEY = 'CartTotal';

    private static final String FAILED_TO_CREATE_LINE_ITEMS = 'Failed to create line items.';
    private static final String FAILED_TO_ADD_ITEMS_TO_CART = 'Failed to add items to the cart.';
    private static final String FAILED_TO_CREATE_CART = 'Failed to create a Cart.';
    private static final String FAILED_TO_CREATE_PRODUCT_QUANTITY_MAP = 'Failed to create Product Quantities Map.';
    private static final String FAILED_TO_CREATE_MINOR_PRODUCT_QUANTITY_MAP = 'Failed to create minor Product Quantities Map.';
    private static final String FAILED_TO_FETCH_CART = 'Failed to fetch cart.';
    private static final String FAILED_TO_FETCH_THE_ACTIVE_CART = 'Failed to fetch the active cart.';
    private static final String FAILED_TO_FETCH_PRICE_FROM_CART = 'Failed to fetch price from cart.';
    private static final String FAILED_TO_PARSE_DETAILS_FROM_CART = 'Failed to parse details from Cart.';


    /**
     * @description Creates line items from the productQuanityMap
     * @param productQuantityMap
     * @return
     */
    private static List<Map<String, Object>> createLineItems(Map<String, Object> productQuantityMap) {
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
            throw new phss_cc_Exception(FAILED_TO_CREATE_LINE_ITEMS);
        }
    }

    /**
     * @description Fetches the relevant cart using the encrypted cart Id.
     *
     * @return
     */
    public static Map<String, Object> cartFetch(String encryptedCartId, Boolean ccApiSizeSkip) {
        Map<String, Object> cartFetchResponse;
        try {
            Map<String, Object> cartFetchRequest = new Map<String, Object>{
                    ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                    ccrz.ccAPICart.CART_ENCID => encryptedCartId,
                    ccrz.ccApi.SIZING => new Map<String, Object>{
                            ccrz.ccAPICart.ENTITYNAME => new Map<String, Object>{
                                    ccrz.ccAPI.SZ_SKIPTRZ => ccApiSizeSkip,
                                    ccrz.ccAPI.SZ_DATA => ccrz.ccAPI.SZ_XL
                            }
                    }
            };
            cartFetchResponse = ccrz.ccApiCart.fetch(cartFetchRequest);
        } catch (Exception e) {
            throw new phss_cc_Exception(FAILED_TO_FETCH_CART);
        }
        return cartFetchResponse;
    }

    /**
     * @description Creates a new cart for the opportunity.
     *
     * @return
     */
    private static String createNewCart() {
        String encryptedCartId = '';
        try {
            Map<String, Object> createCartRequest = new Map<String, Object>{
                    ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION
            };
            Map<String, Object> createCartResponse = ccrz.ccApiCart.create(createCartRequest);
            Boolean isSuccess = (Boolean) createCartResponse.get(ccrz.ccApi.SUCCESS);
            if (isSuccess) {
                encryptedCartId = (String) createCartResponse.get(ccrz.ccApiCart.CART_ENCID);

                ccrz__E_Cart__c cart = [
                        SELECT Id
                        FROM ccrz__E_Cart__c
                        WHERE ccrz__EncryptedId__c = :encryptedCartId
                ];
                cart.Opportunity__c = phss_cc_Context.currOpportunityId;
                cart.ccrz__Account__c = phss_cc_Context.currAccountId;
                upsert cart;
            }
        } catch (Exception e) {
            throw new phss_cc_Exception(FAILED_TO_CREATE_CART);
        }
        return encryptedCartId;
    }

    /**
     * @description Adds the line data to the CC Cart. If encryptedCartId is blank, a new cart is first created.
     *
     * @param productQuantityMap
     * @param encryptedCartId
     *
     * @return
     */
    private static Map<String, Object> cartAddTo(List<Map<String, Object>> lineData, String encryptedCartId) {
        try {

            Map<String, Object> inputData = new Map<String, Object>{
                    ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                    ccrz.ccApiCart.LINE_DATA => lineData,
                    ccrz.ccApiCart.CART_ENCID => encryptedCartId,
                    ccrz.ccAPI.SIZING => new Map<String, Object>{
                            ccrz.ccAPICart.ENTITYNAME => new Map<String, Object>{
                                    ccrz.ccAPI.SZ_REFETCH => true,
                                    ccrz.ccAPI.SZ_DATA => ccrz.ccAPI.SZ_L
                            }
                    }
            };
            return ccrz.ccApiCart.addTo(inputData);
        } catch (Exception e) {
            throw new phss_cc_Exception(FAILED_TO_ADD_ITEMS_TO_CART);
        }
    }

    /**
     * @description Creates a CC Cart and returns the added cart items.
     *
     * @return
     */
    public static Map<String, Object> addProductsToCart(String opportunitySfid, Map<String, Object> productQuantityMap, Boolean fetchMinorItems) {
        try {
            phss_cc_Context.setContext(opportunitySfid);
            Map<String, Object> addProductsToCartResponse;

            String encryptedCartId;

            if (phss_cc_Context.currCart == null) {
                encryptedCartId = createNewCart();
            } else {
                // Get Active cart and clear all cart items.
                encryptedCartId = phss_cc_Context.currCart.ccrz__EncryptedId__c;
                delete [
                        SELECT Id
                        FROM ccrz__E_CartItem__c
                        WHERE ccrz__Cart__c = :phss_cc_Context.currCart.Id
                ];
            }

            List<Map<String, Object>> lineData = createLineItems(productQuantityMap);
            Map<String, Object> addToResult = cartAddTo(lineData, encryptedCartId);
            addProductsToCartResponse = retrieveDetailsFromCart(addToResult, fetchMinorItems);
            return addProductsToCartResponse;
        } catch (Exception e) {
            throw new phss_cc_Exception(e.getMessage());
        }
    }

    /**
     * @description Create a Map<String,Object> of product quanities keyed to product sfid.
     *
     * @return Map<String,Object> Containing Product SFID and associated quanity on cart.
     */
    private static Map<String, Object> getProductQuantitiesMapFromCart(Map<String, Object> currCart, Map<String, Object> majorCartItemToProductSfid, List<String> productListMajorItems, List<String> fullProductList) {
        try {
            Map<String, Object> productQuantityMap = new Map<String, Object>();

            if (currCart.containsKey(CART_ITEMS_KEY)) {
                List<Map<String, Object>> cartItems = (List<Map<String, Object>>) currCart.get(CART_ITEMS_KEY);
                for (Map<String, Object> cartItem : cartItems) {
                    String productSfid = (String) cartItem.get(CART_ITEM_PRODUCT_SFID_KEY);
                    if ((String) cartItem.get(CART_ITEM_TYPE) == CART_ITEM_TYPE_MAJOR) {
                        Decimal productQuantity = (Decimal) cartItem.get(CART_ITEM_QUANTITY_KEY);
                        productQuantityMap.put(productSfid, productQuantity);

                        String cartItemSfid = (String) cartItem.get(CART_ITEM_SFID_KEY);
                        majorCartItemToProductSfid.put(cartItemSfid, productSfid);
                        productListMajorItems.add(productSfid);
                    }
                    fullProductList.add(productSfid);
                }
            }
            return productQuantityMap;
        } catch (Exception e) {
            throw new phss_cc_Exception(FAILED_TO_CREATE_PRODUCT_QUANTITY_MAP);
        }
    }

    /**
     * @description Create a Map<String,Object> of product quanities keyed to product sfid.
     *
     * @return Map<String,Object> Containing Product SFID and associated quanity on cart.
     */
    private static void getMinorLinesFromCart(Map<String, Object> currCart, Map<String, Object> productMap, Map<String, Object> majorCartItemToProductSfid) {
        try {
            if (currCart.containsKey(CART_ITEMS_KEY)) {
                List<Map<String, Object>> cartItems = (List<Map<String, Object>>) currCart.get(CART_ITEMS_KEY);

                for (Map<String, Object> cartItem : cartItems) {

                    if ((String) cartItem.get(CART_ITEM_TYPE) == CART_ITEM_TYPE_MINOR) {

                        // Get the product Sfid and quantity.
                        String productSfid = (String) cartItem.get(CART_ITEM_PRODUCT_SFID_KEY);
                        Decimal productQuantity = (Decimal) cartItem.get(CART_ITEM_QUANTITY_KEY);

                        // Get the parent product for the minor cart item.
                        String parentCartItemSfid = (String) cartItem.get(CART_ITEM_PARENT_CART_ITEM_KEY);
                        String majorCartItemProductSfid = (String) majorCartItemToProductSfid.get(parentCartItemSfid);

                        // Fetch the product details map from the productMap
                        Map<String, Object> productMapDetails = (Map<String, Object>) productMap.get(majorCartItemProductSfid);
                        Map<String, Object> minorProductQuantityMap;

                        // Check if the minorProductQuantityMap exists.
                        if (productMapDetails.containsKey(MINOR_PRODUCT_QUANTITY_MAP_KEY)) {
                            minorProductQuantityMap = (Map<String, Object>) productMapDetails.get(MINOR_PRODUCT_QUANTITY_MAP_KEY);
                        } else {
                            // Map does not exist, create a new map and add the item.
                            minorProductQuantityMap = new Map<String, Object>();
                        }

                        // Add the minor cart item to the minor product quantity map.
                        minorProductQuantityMap.put(productSfid, productQuantity);

                        // Update/Insert the minor product quantity map back into the productMap record.
                        productMapDetails.put(MINOR_PRODUCT_QUANTITY_MAP_KEY, minorProductQuantityMap);
                        productMapDetails.put(MINOR_PRODUCT_LIST_KEY, minorProductQuantityMap.keySet());
                        productMap.put(majorCartItemProductSfid,productMapDetails);
                    }
                }
            }
            System.debug(System.LoggingLevel.DEBUG, 'getMinorLinesFromCart:productMap: ' + JSON.serialize(productMap));
        } catch (Exception e) {
            throw new phss_cc_Exception(FAILED_TO_CREATE_MINOR_PRODUCT_QUANTITY_MAP);
        }
    }

    /**
     * @description Updates the price in the product map to that on the cart.
     *
     * @param productMap
     */
    private static void fetchProductPriceFromCart(Map<String, Object> currCart, Map<String, Object> productMap) {
        try {

            if (currCart.containsKey(CART_ITEMS_KEY)) {
                List<Map<String, Object>> cartItems = (List<Map<String, Object>>) currCart.get(CART_ITEMS_KEY);
                for (Map<String, Object> cartItem : cartItems) {
                    String productSfid = (String) cartItem.get(CART_ITEM_PRODUCT_SFID_KEY);
                    Decimal productPriceOnCart = (Decimal) cartItem.get(CART_ITEM_PRICE_KEY);

                    Map<String, Object> productDetails = (Map<String, Object>) productMap.get(productSfid);

                    productDetails.put(PRODUCT_PRICE_KEY, productPriceOnCart);
                    productMap.put(productSfid, productDetails);
                }
            }
        } catch (Exception e) {
            throw new phss_cc_Exception(FAILED_TO_FETCH_PRICE_FROM_CART);
        }
    }

    /**
     * @description Parses the ccApiCart response.
     *
     * @param cartDetails
     * @param isCart
     *
     * @return
     */
    private static Map<String, Object> retrieveDetailsFromCart(Map<String, Object> cartDetails, Boolean fetchMinorItems) {
        try {
            Decimal cartTotal = 0.00;
            Map<String, Object> productMap = new Map<String, Object>();
            List<String> productListMajorItems = new List<String>();
            List<String> fullProductList = new List<String>();
            Map<String, Object> majorCartItemToProductSfid = new Map<String, Object>();
            Map<String, Object> productQuantityMapFromCart = new Map<String, Object>();

            if (cartDetails.get(ccrz.ccAPICart.CART_OBJLIST) != null) {
                List<Map<String, Object>> returnedCart = (List<Map<String, Object>>) cartDetails.get(ccrz.ccAPICart.CART_OBJLIST);
                Map<String, Object> currCart = (Map<String, Object>) returnedCart[0];
                if (currCart != null) {
                    cartTotal = (Decimal) currCart.get(CART_TOTAL_AMOUNT_KEY);
                    productQuantityMapFromCart = getProductQuantitiesMapFromCart(currCart, majorCartItemToProductSfid, productListMajorItems, fullProductList);
                    productMap = phss_cc_ProductUtil.getProductDetailsKeyedToSfidMap(new Set<String>(fullProductList));

                    if (fetchMinorItems) {
                        getMinorLinesFromCart(currCart, productMap, majorCartItemToProductSfid);
                        fetchProductPriceFromCart(currCart, productMap);
                    }
                }

            }
            return new Map<String, Object>{
                    CART_ENCRYPTED_ID_KEY => phss_cc_Context.currCart.ccrz__EncryptedId__c,
                    CART_TOTAL_KEY => cartTotal,
                    PRODUCT_LIST_KEY => productListMajorItems,
                    PRODUCT_QUANTITY_MAP_KEY => productQuantityMapFromCart,
                    PRODUCT_MAP_KEY => productMap
            };
        } catch (Exception e) {
            throw new phss_cc_Exception(FAILED_TO_PARSE_DETAILS_FROM_CART);
        }

    }

    /**
     * @description Fetches and returns the cart details for the opportunity.
     *
     * @param opportunitySfid
     *
     * @return
     */
    public static Map<String, Object> fetchActiveCart(String opportunitySfid, Boolean fetchMinorItems) {
        try {
            phss_cc_Context.setContext(opportunitySfid);
            Map<String, Object> fetchCartResponse;

            ccrz__E_Cart__c cart = phss_cc_Context.currCart;

            if (cart != null && !String.isEmpty(cart.ccrz__EncryptedId__c)) {
                String currCartEncId = cart.ccrz__EncryptedId__c;
                Map<String, Object> cartDetails = cartFetch(currCartEncId, false);
                fetchCartResponse = retrieveDetailsFromCart(cartDetails, fetchMinorItems);
            }
            return fetchCartResponse;
        } catch (Exception e) {
            throw new phss_cc_Exception(FAILED_TO_FETCH_THE_ACTIVE_CART);
        }
    }
}