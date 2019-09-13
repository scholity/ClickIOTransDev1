({
    doInit : function(component, event, helper) {
        component.set("v.objName","Account");
        component.set("v.objInsName","User");
        helper.getValues(component);
    },
    sortOrgName: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.     
        component.set("v.selectedTabsoft", 'OrganizationName');
        // call the helper function with pass sortField Name   
        // helper.sortHelper(component, event, 'Name');
    },
    fetchIns : function(component, event, helper) {
        
        var action = component.get("c.fetchAchv");
        var orgId 	= component.get("v.selectedAccount")
        var InsId   = component.get("v.selectedInstructor")
        var orgg = [];
        var Ins = [];
        if((orgId!=null||orgId!=undefined||orgId!='') && (InsId==null||InsId==undefined||InsId==''))
        {
            if(orgId == 'All')
            {
                var accountDetailsFromServer = component.get("v.accountList.Accountdetails");
                for(var i in  accountDetailsFromServer)
                {
                    orgg.push(accountDetailsFromServer[i].Id);
                }
            }
            else
                orgg.push(orgId);
        }
        if((orgId==null||orgId==undefined||orgId=='') && (InsId!=null||InsId!=undefined||InsId!=''))
        {
            if(InsId == 'All')
            {
                var userDetailsFromServer = component.get("v.instList.Userdetails");
                for(var i in  userDetailsFromServer)
                {
                    Ins.push(userDetailsFromServer[i].Id);
                }
            }
            else
                Ins.push(InsId);
        }
        if((orgId!=null && InsId!=undefined && orgId!='' && InsId!=''))
        {
            if(orgId == 'All')
            {
                var accountDetailsFromServer = component.get("v.accountList.Accountdetails");
                for(var i in  accountDetailsFromServer)
                {
                    orgg.push(accountDetailsFromServer[i].Id);
                }
            }
            else
                orgg.push(orgId);
            
            if(InsId == 'All')
            {
                var userDetailsFromServer = component.get("v.instList.Userdetails");
                for(var i in  userDetailsFromServer)
                {
                    Ins.push(userDetailsFromServer[i].Id);
                }
            }
            else
                Ins.push(InsId);
        }
        
        console.log('Accountid>>>>>>>>'+orgg);
        console.log('Instructor idd>>>>>>>>'+Ins);
        var idx = event.target.id;
        
        if((orgId!=null && InsId!=null && orgId!='' && InsId!='' && orgId!= undefined && InsId!=undefined))
        {
            action.setParams({accId : JSON.stringify(orgg),instId :JSON.stringify(Ins)});
            
            console.log('Button id>>>>>>>>'+idx);
            action.setCallback(this, function(response){
                
                var state = response.getState();
                console.log('Expected State'+state);
                if (state === "SUCCESS") {
                    var a = response.getReturnValue();
                    console.log('success'+a);
                    console.log('getting inside succes'+JSON.stringify(a));
                    component.set("v.Listss", response.getReturnValue());
                }
            });
            $A.enqueueAction(action);
        }
        
    },
    sortField : function(component, event, helper) {
        var dataset = event.target.dataset;
        console.log('array..'+dataset.array);
        console.log('field..'+dataset.field);
        console.log('order..'+dataset.order);
        helper.sortFields(component, dataset.array, dataset.field, dataset.order);
    },
    downloadDocument : function(component, event, helper){
        var sendData = component.get("v.sendData");
        
        console.log('dataToSend='+component.get("v.Listss"));
        var dataToSend = component.get("v.Listss");
        
        //invoke vf page js method
        sendData(dataToSend, 'PDF', function(){
            //handle callback
        });
    },
    exportDocument : function(component, event, helper){
        var sendData = component.get("v.sendData");
        
        console.log('dataToSend='+component.get("v.Listss"));
        var dataToSend = component.get("v.Listss");
        
        //invoke vf page js method
        sendData(dataToSend, 'XLS', function(){
            //handle callback
        });
    }
})