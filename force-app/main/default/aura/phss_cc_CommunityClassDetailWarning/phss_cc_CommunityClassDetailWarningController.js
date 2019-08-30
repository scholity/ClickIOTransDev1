({
	toggleCheckbox : function(component, event, helper) {
		var isChecked = component.find("acknowledgmentCheckbox").get("v.checked");

		console.log("About to fire userAcknowledgesClassDate event");
		var acknowledgmentEvent = component.getEvent("acknowledgeClassDate");
		acknowledgmentEvent.setParams({"userAcknowledgesClassDate": isChecked});
		acknowledgmentEvent.fire();
		console.log("userAcknowledgesClassDate event fired.");
	}
})