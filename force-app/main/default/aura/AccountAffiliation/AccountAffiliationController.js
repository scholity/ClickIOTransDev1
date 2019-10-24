({
    doInit : function(component, event, helper) {
        helper.getRecords(component, event, helper);
    },
    handleIsSelectAll : function(component, event, helper) {
        if(component.get("v.isSelectAll"))
        {
            var accConList = component.get("v.accountContactsList");
            for(var i = 0; i < accConList.length; i++)
            {
                accConList[i].isChecked = true;
            }
            component.set("v.accountContactsList",accConList);            
        }
        else
        {
            var accConList = component.get("v.accountContactsList");
            for(var i = 0; i < accConList.length; i++)
            {
                accConList[i].isChecked = false;
            }
            component.set("v.accountContactsList",accConList); 
        }
    },
    removeAffiliation : function(component, event, helper) {
        helper.removeAffiliation(component, event, helper);
    }
})