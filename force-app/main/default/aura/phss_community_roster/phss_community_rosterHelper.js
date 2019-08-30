({
    getData : function(component) {
        var recordId = component.get("v.recordId");
        var object = component.get("v.object");
        var doclist = component.get("v.doclist");
        var prepMail = component.get("v.prepMail");

        if($A.util.isEmpty(recordId)){
            var recordIdpattern = new RegExp("[?&]recordId=(([^&]*)&?|&|$)");
            var urlRecordId = recordIdpattern.exec(location.href);
            //var urlRecordId = /[?&]urlRecordId(=([^&]*)|&|$)/.exec(location.href);
            if (urlRecordId != null && urlRecordId.length > 2 && urlRecordId[2] != null && urlRecordId[2].length > 2) {
                recordId = urlRecordId[2];
            }
        }
        console.log("recordId: " + recordId );
        var planId = '';
        var planIdpattern = new RegExp("[?&]pId=(([^&]*)&?|&|$)");
        var urlPlanId = planIdpattern.exec(location.href);        
        //var urlPlanId = /[&]pId(=([^&]*)|&|$)/.exec(location.href);
        if (urlPlanId != null && urlPlanId.length > 2 && urlPlanId[2] != null && urlPlanId[2].length > 2) {
            planId = urlPlanId[2];
        }
        console.log("planId: " + planId);
        // TEST SET VALUES
        //     recordId = 'a315B0000005wRwQAI'
        //     planId = 'a3r5B000000AfWdQAK'
        console.log("recordId: " + recordId );
        console.log("doclist: " + doclist );
        console.log("object: " + object );

        // var sdocURL = component.get("v.sdocURL");
         var sdocURL = '';       
         var urlString = window.location.href;
         var baseURL = urlString.substring(0, urlString.indexOf("/s"));
         sdocURL = 'https://'+baseURL+'/apex/SDOC__SDCreate1?id='+recordId+'&Object='+object+'&doclist='+doclist+'&prepmail='+prepMail;
         console.log("sdocURL: " + sdocURL );
                  
        var action = component.get("c.getData");
        action.setParams({ "sdocURL" : sdocURL });
        //Set any optional callback and enqueue the action
        //if (callback) {
        //    action.setCallback(this, callback);
       // }
       // $A.enqueueAction(action);
    }
})