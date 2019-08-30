({
    doInit : function (component, event, helper) {
        var storedPaymentMap = component.get('v.storedPaymentMap');
        var storedPaymentSfid = component.get('v.storedPaymentSfid');
        
        console.log("****storedPaymentMap****"+storedPaymentMap);
        console.log("****storedPaymentSfid****"+storedPaymentSfid);
        

        var storedPayment = storedPaymentMap[storedPaymentSfid];
        
        console.log("****storedPayment****"+storedPayment);
        
        component.set('v.storedPayment', storedPayment);
    },

    handleSelected :  function (component, event, helper) {
        var storedPaymentSfid = component.get('v.storedPaymentSfid');
        
        console.log("$$$storedPaymentSfid$$$"+storedPaymentSfid);
        var updateEvent = component.getEvent('sendSelectedPO');
        updateEvent.setParams({'POSfid': storedPaymentSfid});
        updateEvent.fire();
    }
})