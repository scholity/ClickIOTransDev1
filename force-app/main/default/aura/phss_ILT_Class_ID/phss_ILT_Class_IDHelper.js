({
    getData : function(component) {
        var recordId = component.get("v.recordId");
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
    //    recordId = 'a315B0000006MljQAE'
    //    planId = 'a3r5B000000AfWdQAK'
        console.log("recordId: " + recordId );
        
        var action = component.get("c.getData");
        action.setParams({ "recordId" : recordId });    
    }
})