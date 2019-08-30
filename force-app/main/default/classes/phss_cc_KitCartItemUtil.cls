public class phss_cc_KitCartItemUtil {

    private static final String CLASS_UNIT_OF_MEASURE       = 'CLASS';
    private static final String INSTRUCTOR_UNIT_OF_MEASURE  = 'INSTRUCTOR';
    private static final String KIT_PRODUCT_TYPE            = 'KIT';
    private static final String MINOR_CART_ITEM_TYPE        = 'Minor';


    public static void updateKitMinorCartItemQuantities(String cartId) {

        List<ccrz__E_CartItem__c> cartItems = new List<ccrz__E_CartItem__c>();
        List<ccrz__E_CartItem__c> kitCartItems = getKitCartItems(cartId);
        List<ccrz__E_CartItem__c> minorCartItems = getMinorCartItems(cartId);

        for (ccrz__E_CartItem__c kitCartItem : kitCartItems) {
            for (ccrz__E_CartItem__c minorCartItem : minorCartItems) {
                if (kitCartItem.ccrz__CartItemId__c == minorCartItem.ccrz__CartItemId__c) {
                    Decimal numberOfStudents = kitCartItem.ccrz__Product__r.Course_Catalog__r.Number_of_Students__c;
                    resetQuantityForCartItem(minorCartItem, numberOfStudents);
                    cartItems.add(minorCartItem);
                }
            }
        }

        update cartItems;
    }

    /**
     * @description Returns a list of KIT cart items from a specified cart
     *
     * @param cartId
     *
     * @return
     */
    private static List<ccrz__E_CartItem__c> getKitCartItems(String cartId) {
        return [
                SELECT Id, Name, ccrz__CartItemId__c, ccrz__Category__c, ccrz__Price__c, ccrz__UnitOfMeasure__c,
                       ccrz__Quantity__c, ccrz__SubAmount__c, ccrz__ItemTotal__c, ccrz__Product__c,
                       ccrz__Product__r.Name, ccrz__Product__r.Course_Catalog__c,
                       ccrz__Product__r.Course_Catalog__r.Number_of_Students__c, ccrz__Cart__c
                  FROM ccrz__E_CartItem__c
                 WHERE ccrz__Cart__c = :cartId
                   AND ccrz__ProductType__c = :KIT_PRODUCT_TYPE
                 ORDER BY ccrz__CartItemId__c
        ];
    }

    /**
     * @description Returns a list of minor cart items from a specified cart
     *
     * @param cartId
     *
     * @return
     */
    private static List<ccrz__E_CartItem__c> getMinorCartItems(String cartId) {
        return [
                SELECT Id, Name, ccrz__Cart__c, ccrz__CartItemId__c, ccrz__CartItemType__c, ccrz__Price__c,
                       ccrz__SubAmount__c, ccrz__UnitOfMeasure__c, ccrz__Product__c, ccrz__ItemTotal__c,
                       ccrz__ParentCartItem__c, ccrz__Quantity__c
                  FROM ccrz__E_CartItem__c
                 WHERE ccrz__Cart__c = :cartId
                   AND ccrz__UnitOfMeasure__c IN (:CLASS_UNIT_OF_MEASURE, :INSTRUCTOR_UNIT_OF_MEASURE)
                   AND ccrz__CartItemType__c = :MINOR_CART_ITEM_TYPE
                 ORDER BY ccrz__ParentCartItem__c
        ];
    }

    /**
     * @description Modifies the quantity for a cart item
     *
     * @param cartItem
     * @param numberOfStudents
     */
    private static void resetQuantityForCartItem(ccrz__E_CartItem__c cartItem, Decimal numberOfStudents) {

        if (numberOfStudents != 0) {

            Decimal quantity = cartItem.ccrz__Quantity__c;
            Decimal ratio = quantity / numberOfStudents;

            if (ratio < 0) {
                cartItem.ccrz__Quantity__c = Math.floor(ratio);
            } else {
                cartItem.ccrz__Quantity__c = Math.ceil(ratio);
            }
        }
    }
}