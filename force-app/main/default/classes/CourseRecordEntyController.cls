public class CourseRecordEntyController {
    
	@AuraEnabled 
    public static user fetchUser(){
       
      User oUser = [select id,Name 
                 FROM User Where id =: userInfo.getUserId()];
        return oUser;
    }
    
    @AuraEnabled
    public static void SaveRegistrationDetail(redwing__ILT_Class__c regForm ){
        system.debug('***regForm***'+regForm);
     // DML operation to save RegForm Details   
     insert regForm;
     
    }
}