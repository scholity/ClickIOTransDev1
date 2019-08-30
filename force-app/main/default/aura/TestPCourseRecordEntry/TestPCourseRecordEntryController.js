({
    doInit : function(component, event, helper) {
        
        var action = component.get("c.fetchUser");
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var storeResponse = response.getReturnValue();
               
                component.set("v.instructor", storeResponse);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    showStep0 : function(component,event,helper){
        component.set("v.stepNumber", "Zero");
    },
    
    showStep1 : function(component,event,helper){
        /*var t = component.get("v.selectedLookUpRecord1");
		t = JSON.stringify(t);
        console.log(t); */
        component.set("v.stepNumber", "One");
        //component.set("v.selectedLookUpRecord1", t);
        //console.log(t);
        //console.log(JSON.stringify(component.get("v.selectedLookUpRecord1")));
    },
    
    showStep2 : function(component,event,helper){
        component.set("v.stepNumber", "Two");
    },
    
    showStep3 : function(component,event,helper){
        component.set("v.stepNumber", "Three");
        component.set("v.messageType", '' );
		component.set("v.message", '' );
    },
    
    showStep4 : function(component,event,helper){
        component.set("v.messageType", '' );
		component.set("v.message", '' );
        component.set("v.stepNumber", "Four");
    },
    
    
    
    onclickNext : function(component,event,helper){
        var currentSN = component.get("v.stepNumber");
        console.log(currentSN);
        
        if(currentSN == "One")
        {
            
            //Number of Students
            var numOfStudents = component.get("v.Students");
            var action = component.get("c.initializeStudents");
    		action.setParams({Count : component.get("v.Students")});
            action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();   
                component.set("v.numberOfStudentsList", storeResponse);
            }
        	});
            $A.enqueueAction(action);
            
            /*for (i = 0; i < numOfStudents; i++)
            {
                numOfStudentsList.push(numOfStudentsList.length + 1);                            
            }
            component.set("v.numberOfStudentsList",numOfStudentsList); */
            
            //Organization
            var accountId = component.get("v.selectedLookUpRecord1").Id;
            component.set("v.accId",accountId);
            
            var accountName = component.get("v.selectedLookUpRecord1").Name;
            component.set("v.accName",accountName);
            
            //Course
            var crsId =  component.get("v.selectedLookUpRecord2").Id;
            component.set("v.courseId",crsId);
            
            var crsName =  component.get("v.selectedLookUpRecord2").Name;
            component.set("v.courseName",crsName);
            
            //Course Ending Date            
            var endDate = component.get("v.EndDate");
            
            // User 1            
            var instructor1 = component.get("v.Instructor1");                    
            
            // User 2            
            var instructor2Id = component.get("v.selectedLookUpRecord3").Id;
            component.set("v.userId2",instructor2Id);
            
            var instructor2Name = component.get("v.selectedLookUpRecord3").Name;
            component.set("v.userName2",instructor2Name);
            
            //Training Site
            var tSite = component.get("v.Location");
            
            //Navigate to Step 2
            component.set("v.stepNumber", "Two");
            
        }
        
        else if(currentSN == "Two")
        {
            /*var inputfn = component.find("firstName");
            var inputln = component.find("LastName");
            var inputei = component.find("Emailid");
            var inputpn = component.find("Phoneno");
            var inputgi = component.find("Gradeid");
            var inputfr = component.find("Failrs");
            
            var valuefn = inputfn.get("v.value");
			var valueln = inputln.get("v.value");
            var valueei = inputei.get("v.value");
            var valuepn = inputpn.get("v.value");
            var valuegi = inputgi.get("v.value");
            var valuefr = inputfr.get("v.value");
            console.log("checkfield fn value" +valuefn);

         	 // Is input numeric?
        	if (valuefn != '' || valuefn != null ) {
            // Set error
            console.log("firstnamefield" +valuefn);
            //inputCmp.set("v.errors", [{message:"Provide values for the first name: " + value}]);
        	} else {
            // Clear error
            console.log("firstnamefieldelse" +valuefn);
            //inputCmp.set("v.errors", null);
        	} */
            component.set("v.stepNumber", "Three");
            
        }
        
        else if(currentSN == "Three")
        {
            component.set("v.stepNumber", "Four");
            component.set("v.messageType", '' );
	  cmp.set("v.message", '' );
        }
        
        else if(currentSN == "Four")
        {
        	component.set("v.stepNumber", "Complete");
        }
        
    },
    
    
    processCRE : function(cmp, evt, hlpr)
    {    
        cmp.set("v.messageType", '' );
						cmp.set("v.message", '' );
        //var myBool = cmp.get("v.myBool");
        //Organization
        var accID = cmp.get("v.accId");
        
        //Course
        var course =  cmp.get("v.courseId");
        
        //Course Ending Date            
        var endDate   = cmp.get("v.EndDate");
        var splitDate = endDate.split('-');
        
        var year 	  = splitDate[0];
        var month     = splitDate[1];
        var day 	  = splitDate[2]; 
        
        var endDateFrmtd = month + '/' + day + '/' + year;
        
        // User            
        var user1 = cmp.get("v.Instructor1"); 
        var user2 = cmp.get("v.Instructor2"); 
        
        //Number of Students
        var numOfStudents = cmp.get("v.Students");
        console.log("numOfStudents" +numOfStudents);
        
        //Training Site
        var tSite = cmp.get("v.Location");
        var obj = new Object();
        
        obj.Account		=	accID;		//0015B00000SelPZQAZ
        obj.Course		=	course;		//a3r5B000000AfWd
        obj.EndDate		=	endDateFrmtd;
        obj.Students	=	numOfStudents;
        obj.Instructor1 =	"0050V000006ld8r"; //user1
        obj.Instructor2 =	user2;
        obj.Location	=	tSite;
        
        console.log(obj);

       var classDetailJSON = JSON.stringify(obj);
        //Forming the json which accepts ILT Class details format
        classDetailJSON = '{'+'\"ClassDetails\": '+classDetailJSON+'}';
        console.log("***classDetailJSON***"+classDetailJSON);
        //Calling the server to assign the organization, location and etc in ILT Class & Session
        // Creating Json format and assigning the grades for that student(Passing value to server side controller)
         var studentDetails = cmp.get("v.numberOfStudentsList");
                 var ids=new Array();
                 var jsonStr = '';
				 for (var idx=0; idx<studentDetails.length; idx++) {
                     jsonStr += JSON.stringify(studentDetails[idx]);
                     if(idx != (studentDetails.length)-1)
                         jsonStr+=',';
             	 }
                 console.log(jsonStr);
                 jsonStr = '{'+'\"Students\": ['+jsonStr+'] } ';
                 console.log(jsonStr);
        
                var action = cmp.get("c.invokeMethods");
                action.setParams({ JSON : classDetailJSON, JSON1 : jsonStr });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    console.log(state);
                    if (state === "SUCCESS") {
                        cmp.set("v.messageType", 'success' );
						cmp.set("v.message", 'Completed Successfully!' );
                    }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + 
                                         errors[0].message);
                                cmp.set("v.messageType", 'error');
								cmp.set("v.message", errors[0].message );
                                
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
                   
                });
                
           	     $A.enqueueAction(action);
                 //$A.enqueueAction(action1);
        
    
        
        
        
        
        
        /*var action = cmp.get("c.addStudents");
        action.setParams({ studentsJSON : cmp.get("v.studentsJSON")});
        action.setCallback(this, function(response) 
        $A.enqueueAction(action)*/
        
        //var action = cmp.get("c.createOrder");
        //action.setParams({ orderJSON : cmp.get("v.orderJSON")});
        //action.setCallback(this, function(response) {…}
        //$A.enqueueAction(action)
	},
    
    cancel : function(component, event, helper){
        
        component.set("v.stepNumber", "Zero");
        
        component.set("v.Account", "");
        component.set("v.Course", "");
        component.set("v.EndDate", "");
        component.set("v.Students", "");
        component.set("v.Instructor1", "");
        component.set("v.Instructor2", "");
        component.set("v.Location", "");
        component.set("v.numberOfStudentsList", "[]");        
    }

})