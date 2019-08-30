({
    doInit: function(component, event, halper) {
    	var sPageURL = decodeURIComponent(window.location.search.substring(1)); //You get the whole decoded URL of the page.
        var indx = sPageURL.indexOf('startURL');
        sPageURL = sPageURL.substring(indx+9);
        component.set("v.startUrl",sPageURL);    
    },
	inputCheck : function(component, event, helper) {
        helper.inputCheck(component, helper);
        helper.someTestMethod(component);
//        if (component.get("v.valid")) {
//            console.log('running call to register');
//            helper.selfRegister(component);
//        }
	}
})