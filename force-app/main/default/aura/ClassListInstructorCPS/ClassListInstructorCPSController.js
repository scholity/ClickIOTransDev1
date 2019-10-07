({
    doInit : function(component, event, helper) {
        //Set Start Date
        var today = new Date();
        var ddStart = today.getDate();
        var mmStart = today.getMonth()+1; 
        var yyyyStart = today.getFullYear();
        if(ddStart<10) 
        {
            ddStart ='0'+ddStart;
        } 
        
        if(mmStart<10) 
        {
            mmStart ='0'+mmStart;
        } 
        today = yyyyStart+'/'+mmStart+'/'+ddStart;
        component.set("v.StartDateFrom",today);
        
        //Set End Date
        var endDate = new Date(); 
        endDate.setDate(endDate.getDate() + 30);
        var ddEnd = endDate.getDate();
        var mmEnd = endDate.getMonth()+1; 
        var yyyyEnd = endDate.getFullYear();
        if(ddEnd<10) 
        {
            ddEnd ='0'+ddEnd;
        } 
        
        if(mmEnd<10) 
        {
            mmEnd ='0'+mmEnd;
        } 
        endDate = yyyyEnd+'/'+mmEnd+'/'+ddEnd;
        component.set("v.StartDateTo",endDate);
        
        component.set("v.objName","Account");
        helper.getValues(component, helper);
    },
    
    getInstructorValues : function(component, event, helper) {
        if(component.get("v.selectedAccount") == "") {
            component.set("v.selectedInstructor","");
        }    
        else { 
            component.set("v.objName","User");
            helper.getValues(component, helper); 
        }
        helper.getData(component, helper);
    },
    
    getInstClasses : function(component, event, helper) {
        helper.getData(component, helper);
    },
    
    getClassesOnChangeDate : function(component, event, helper) {
        helper.getData(component, helper);
    },
    
    getClassesOnChangeLookUp : function(component, event, helper) {
        if(component.get("v.selectedLookUpRecord") != '' && component.get("v.selectedLookUpRecord") != null && component.get("v.selectedLookUpRecord") != {})
            helper.getData(component, helper);
    },
    
    goToDetail : function(component, event, helper){
        var url = location.href;
        url= url.split('/s/');
        //window.location.href = url[0] + '/s/ilt-detail?recordId=' + event.target.dataset.id + '&pId=' + (event.target.dataset.pid ? event.target.dataset.pid : 'null'); 
        window.open('../s/ilt-detail?recordId=' + event.target.dataset.id + '&pId=' + (event.target.dataset.pid ? event.target.dataset.pid : 'null'), '_parent');
    },
    
    sortField : function(component, event, helper) {
        var dataset = event.target.dataset;
        helper.sortFields(component, dataset.field, dataset.order);
    },
    
    downloadDocumentCurrent : function(component, event, helper){
        var sendData = component.get("v.sendData");
        
        console.log('dataToSend='+component.get("v.Classes"));        
        var dataToSend = component.get("v.Classes");
        
        //invoke vf page js method
        sendData(dataToSend, 'PDF', function(){
            //handle callback
        });
    },
    
    exportDocumentCurrent : function(component, event, helper){
        var sendData = component.get("v.sendData");
        
        console.log('dataToSend='+component.get("v.Classes"));        
        var dataToSend = component.get("v.Classes");
        
        //invoke vf page js method
        sendData(dataToSend, 'XLS', function(){
            //handle callback
        });
    }
})