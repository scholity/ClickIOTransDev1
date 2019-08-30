({
    onLoad: function(component, event, sortField) {
      //call apex class method
      var action = component.get('c.fetchsortedAccountDetails');
 
      // pass the apex method parameters to action 
      action.setParams({
         "sortField": sortField,
         "isAsc": component.get("v.isAsc"),
          "objName" : component.get("v.objName"),
            "objInsName":component.get("v.objInsName"),
            "accId"   : component.get("v.selectedAccount")
      });
      action.setCallback(this, function(response) {
         //store state of response
         var state = response.getState();
         if (state === "SUCCESS") {
            //set response value in ListOfContact attribute on component.
           // component.set('v.ListOfContact', response.getReturnValue());
         }
      });
      $A.enqueueAction(action);
   },
 
   sortHelper: function(component, event, sortFieldName) {
      var currentDir = component.get("v.arrowDirection");
 
      if (currentDir == 'arrowdown') {
         // set the arrowDirection attribute for conditionally rendred arrow sign  
         component.set("v.arrowDirection", 'arrowup');
         // set the isAsc flag to true for sort in Assending order.  
         component.set("v.isAsc", true);
      } else {
         component.set("v.arrowDirection", 'arrowdown');
         component.set("v.isAsc", false);
      }
      // call the onLoad function for call server side method with pass sortFieldName 
      this.onLoad(component, event, sortFieldName);
   },
 
    getValues : function(component) {
        var action = component.get("c.getPicklistValues");
        console.log('objName..'+component.get("v.objName"));
        console.log('accId..'+component.get("v.selectedAccount"));
        action.setParams({
            "objName" : component.get("v.objName"),
            "objInsName":component.get("v.objInsName"),
            "accId"   : component.get("v.selectedAccount")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var result = response.getReturnValue();
                if (state === 'SUCCESS') {
                    console.log('Expected result'+JSON.stringify(result));
                    
                    // if(component.get("v.objName") == "Account") {
                    component.set("v.accountList",result);
                    
                    component.set("v.instList",result);
                    
                    
                    
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
    sortBy: function(component, field) {
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            Listss = component.get("v.Listss");
        sortAsc = field == sortField? !sortAsc: true;
        records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = a[field] > b[field];
            return t1? 0: (sortAsc?-1:1)*(t2?-1:1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.records", Listss);
    }
})