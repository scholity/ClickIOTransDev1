({
    uploadHelper: function(component, event) {
        
        component.set("v.showLoadingSpinner", true);
        
        var fileInput = component.find("fileId").get("v.files");
        
        var file = fileInput[0];
        var self = this;
        
        var objFileReader = new FileReader();
        
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
 
            fileContents = fileContents.substring(dataStart);
            
            self.uploadInChunk(component, file, fileContents);
        });
 
        objFileReader.readAsDataURL(file);
    },
    
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId) {
        
        var action = component.get("c.saveChunk");
        action.setParams({
            base64Data: encodeURIComponent(fileContents),
            contentType: file.type
        });
        
        action.setCallback(this, function(response) {
            
            attachId = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                alert('your File is uploaded successfully');
                component.set("v.showLoadingSpinner", false);
            } 
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action);
    }
})