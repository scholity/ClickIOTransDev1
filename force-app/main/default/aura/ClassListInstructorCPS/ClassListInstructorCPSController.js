({
    doInit : function(component, event, helper) {
        component.set("v.objName","Account");
        helper.getValues(component);
        helper.getData(component);
    },
    
    getInstructorValues : function(component, event, helper) {
        if(component.get("v.selectedAccount") == "") {
            component.set("v.selectedInstructor","");
        }    
        else { 
            component.set("v.objName","User");
            helper.getValues(component); 
        }
        helper.getData(component);
    },
    
    getInstClasses : function(component, event, helper) {
        helper.getData(component);
    },
    
    getClassesOnChangeDate : function(component, event, helper) {
        helper.getData(component);
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