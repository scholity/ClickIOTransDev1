({
    getValues : function(component, helper) {
        var action = component.get("c.getPicklistValues");
        action.setParams({
            "objName" : component.get("v.objName"),
            "accId"   : component.get("v.selectedAccount")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var result = response.getReturnValue();
                if (state === 'SUCCESS') {
                    if(component.get("v.objName") == "Account") {
                        component.set("v.accountList",result);    
                    }
                    else {
                        component.set("v.instList",result);
                        if(component.get("v.instList").length == 1) {
                            component.set("v.selectedInstructor",component.get("v.instList")[0].Id);
                        }
                        else {
                            component.set("v.selectedInstructor","");
                        }
                    }
                } 
                else {
                    console.log('error');
                }
            } 
            else {
                console.log('error');
            }
        });
        $A.enqueueAction(action);	
    },
    
    toggleSpinner:function(component, helper) {
        component.set('v.loadingSpinner', !component.get('v.loadingSpinner')); 
    },
    
    getData : function(component, helper) {
        helper.toggleSpinner(component, helper);
        var action = component.get("c.getClasses");
        console.log('account..'+component.get("v.selectedAccount"));
        console.log('instructor..'+component.get("v.selectedInstructor"));
        console.log('selectedLookUpRecord..'+component.get("v.selectedLookUpRecord"));
        //alert(JSON.stringify(component.get("v.selectedLookUpRecord")));
        var startDateFromVar;
        var startDateToVar;
        var courseId;
        if(component.get("v.StartDateFrom") != '')
            startDateFromVar = component.get("v.StartDateFrom");
        if(component.get("v.StartDateTo") != '')
            startDateToVar = component.get("v.StartDateTo");
        if(component.get("v.selectedLookUpRecord") != '' && component.get("v.selectedLookUpRecord") != null && component.get("v.selectedLookUpRecord") != {})
            courseId = component.get("v.selectedLookUpRecord").Id;
        //courseId = "a3r5B00000068C7QAI";
        action.setParams({
            "offset"      : component.get("v.offset"),
            "limitOffset" : component.get("v.limitOffset"),
            "accId"       : component.get("v.selectedAccount"),
            "instructorId": component.get("v.selectedInstructor"),
            "startDateFrom" : startDateFromVar,
            "startDateTo" : startDateToVar,
            "courseId" : courseId
        });
        
        action.setCallback(this, function(response) {
            helper.toggleSpinner(component, helper);
            var state = response.getState();
            if (state === 'SUCCESS') {
                var result = response.getReturnValue();
                
                if (state === 'SUCCESS') {
                    component.set('v.Classes', result);
                    this.sortFields(component, 'startDate', 'asc');
                } else {
                    console.log('error');
                }
                
            } else {
                console.log('error');
            }
        });
        
        $A.enqueueAction(action);
    },
    
    sortFields : function(component, field, order) {
        var resultArray = component.get("v.Classes");
        resultArray = resultArray.sort(function(first, second){
            var a = first[field];
            var b = second[field];
            if(a > b) {
                return order === 'asc' ? 1 : -1;
            } else if(a < b) {
                return order === 'asc' ? -1 : 1;
            } else {
                return 0;
            }
        });
        component.set("v.sortField", field);
        component.set("v.sortOrder", order);
        component.set("v.Classes", resultArray);
    },
})