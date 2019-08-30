/**
 * Created by dgajwani on 9/22/18.
 */
({
    /**
     * @description Find the product in the productMap and makes the product data available.
     * @param component
     * @param event
     * @param helper
     */
    doInit: function (component, event, helper) {
        var productQuantityMap = component.get('v.productQuantityMap');
        var productsMap = component.get('v.productMap');
        var productSfid = component.get('v.productSfid');

        var product = productsMap[productSfid];
        component.set('v.productCount', 0);
        // if (!isNaN(productQuantityMap[productSfid])) {
        //     component.set('v.productCount', productQuantityMap[productSfid]);
        // }
        // else {
        //     component.set('v.productCount', 0);
        // }
        component.set('v.product', product);

    },

    /**
     * @description Event handler for the + button.
     * @param component
     * @param event
     * @param helper
     */
    incrementProduct: function (component, event, helper) {
        var productSfid = component.get('v.product.sfid');
        var productCount = component.get('v.productCount');
        var productInventory = component.get('v.product.inventoryCount');
        if (productCount == productInventory) {
            return;
        }
        productCount = Number(productCount) + 1;
        component.set('v.productCount', productCount);
        var updateEvent = component.getEvent('incrementProductCount');
        updateEvent.setParams({'productSfid': productSfid});
        updateEvent.fire();
    },

    /**
     * @description Event handler for the - button.
     * @param component
     * @param event
     * @param helper
     */
    decrementProduct: function (component, event, helper) {
        var productSfid = component.get('v.product.sfid');
        var productCount = component.get('v.productCount');
        if (productCount == 0) {
            return;
        }
        productCount = Number(productCount) - 1;
        component.set('v.productCount', productCount);
        var updateEvent = component.getEvent('decrementProductCount');
        updateEvent.setParams({'productSfid': productSfid});
        updateEvent.fire();
    }
})