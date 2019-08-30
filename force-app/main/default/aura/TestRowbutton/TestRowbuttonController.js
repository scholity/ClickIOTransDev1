({
	  CloseClassButtonHandler : function(component,event,helper){
          alert('came in');
          console.log('Came in...');
        var EvntPayload = event.getParam("name");
        //component.set("v.recordId", EvntPayload);
        //helper.fetchClassDetails(component, event, helper);
        console.log('get values..');
        alert('Get recorddd idd'+EvntPayload);
    }
})