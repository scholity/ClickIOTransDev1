({
	doInit: function(component, event, helper) {
        
        // get the fields API name and pass it to helper function  
        var controllingFieldAPI = component.get("v.controllingFieldAPI");
        var dependingFieldAPI = component.get("v.dependingFieldAPI");
        var objDetails = component.get("v.objDetail");
        // call the helper function
        helper.fetchPicklistValues(component,objDetails,controllingFieldAPI, dependingFieldAPI);
        
        //
        
        var orderId = component.get("v.recordId");
        
        console.log("***orderId***"+orderId);
        
        var action = component.get('c.getOrderItemDetail');
        action.setParams({ orderId : orderId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var storeResponse = response.getReturnValue();
                
                component.set("v.orderItemList", storeResponse);
                
                var cancelBln	= component.get("v.isCancel");
                var refundBln	= component.get("v.isRefund");
                var replaceBln  = component.get("v.isReplace");
                
                if(cancelBln)
                {
                    component.set("v.price",storeResponse[0].ccrz__Price__c);
                    component.set("v.subAmount",storeResponse[0].ccrz__SubAmount__c);
                    component.set("v.qty",storeResponse[0].ccrz__Quantity__c);
                }
                if(refundBln)
                {
                    var newPrice = storeResponse[0].ccrz__Price__c * -1;
                    var newSubAmount = storeResponse[0].ccrz__SubAmount__c  * -1;
                    component.set("v.price",newPrice);
                    component.set("v.subAmount",newSubAmount);
                    component.set("v.qty",storeResponse[0].ccrz__Quantity__c);
                    
                }
                if(replaceBln)
                {
                    component.set("v.price",0);
                    component.set("v.subAmount",0);
                    component.set("v.qty",storeResponse[0].ccrz__Quantity__c);
                }
                
                console.log(storeResponse[0].ccrz__Price__c );
            }
        });
        $A.enqueueAction(action);
    },
    
    onControllerFieldChange: function(component, event, helper) {     
        var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        var depnedentFieldMap = component.get("v.depnedentFieldMap");
        
        if (controllerValueKey != '--- None ---') {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
            
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);  
                helper.fetchDepValues(component, ListOfDependentFields);    
            }else{
                component.set("v.bDisabledDependentFld" , true); 
                component.set("v.listDependingValues", ['--- None ---']);
            }  
            
        } else {
            component.set("v.listDependingValues", ['--- None ---']);
            component.set("v.bDisabledDependentFld" , true);
        }
    },
})