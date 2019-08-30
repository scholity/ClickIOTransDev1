({
    handleClick: function(component, event, helper) {
         helper.getData(component, event.getParam("sdocURL"));
         console.log("helper finish: " );
         console.log("helper finish: " + sdocURL );
         }
       //  getData: function(component, sdocURL) {
       //  console.log("get data finish: " );
 
      //  var attr_value = component.get("v.sdocURL");
		// Find the text value of the component with aura:id set to "address"
    //	var address = component.find("address").get("v.value");
     //   console.log("address: " + attr_value );
  
       // var urlEvent = $A.get("e.force:navigateToURL");
       // urlEvent.setParams({
       //     "url": attr_value
       // });
       // urlEvent.fire();
       // console.log("Failed with state: " + state);

	// } 
})