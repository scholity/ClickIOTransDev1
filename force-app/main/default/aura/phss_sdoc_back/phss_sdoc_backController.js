({
   handleClick: function(component, event, helper) {
       console.log("Start "  );
        var recordId = component.get("v.recordId");
        var object = component.get("v.object");
        var doclist = component.get("v.doclist");
        var prepMail = component.get("v.prepMail");
        var btnClicked = event.getSource(); // the button
        var btnMessage = btnClicked.get("v.value"); // the button value
       
        if($A.util.isEmpty(recordId)){
            var recordIdpattern = new RegExp("[?&]recordId=(([^&]*)&?|&|$)");
            var urlRecordId = recordIdpattern.exec(location.href);
            //var urlRecordId = /[?&]urlRecordId(=([^&]*)|&|$)/.exec(location.href);
            if (urlRecordId != null && urlRecordId.length > 2 && urlRecordId[2] != null && urlRecordId[2].length > 2) {
                recordId = urlRecordId[2];
            }
        }
       
        console.log("Lplan B " + LplanId);           
       // var LplanId = classMap[recordId];
        var LplanId = component.get(v.myRecord.Learning_Plan__c);
        component.set('v.LplanId', LplanId);
 
        console.log("Lplan a" + LplanId );
       
        var planId = '';
        var planIdpattern = new RegExp("[?&]pId=(([^&]*)&?|&|$)");
        var urlPlanId = planIdpattern.exec(location.href);        
        //var urlPlanId = /[&]pId(=([^&]*)|&|$)/.exec(location.href);
        if (urlPlanId != null && urlPlanId.length > 2 && urlPlanId[2] != null && urlPlanId[2].length > 2) {
            planId = urlPlanId[2];
        }
        console.log("LplanId: " + LplanId);
        console.log("planId: " + planId);
        console.log("recordId: " + recordId );
        console.log("object: " + object );
 
        var sdocURL = ' ';
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s"));
        // sdocURL = baseURL+'/apex/SDOC__SDCreate1?id='+recordId+'&Object='+object+'&doclist='+doclist+'&prepmail='+prepMail+'&Site='+baseURL;
        sdocURL = baseURL+'/s/ilt-detail?recordId='+recordId+'&pId='+LplanId;
        console.log("sdocURL: " + sdocURL );
        
        component.set("v.sdocURL", sdocURL);
      
           var attr_value = component.get("v.buttonURL");
		// Find the text value of the component with aura:id set to "address"
    	var address = component.find("address").get("v.value");
        var urlEvent = $A.get("e.force:navigateToURL");
        //urlEvent.setParams({"url": attr_value});
        urlEvent.setParams({"url": sdocURL});
        urlEvent.fire();
     
   }
})