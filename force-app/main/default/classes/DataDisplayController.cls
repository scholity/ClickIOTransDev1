public class DataDisplayController {
    public List<PHSS_ClassListInstructorViewController.classWrapper> classWrapperList {get; set;} 
    public String PDFData{get; set;} 
    
    public DataDisplayController(){
        Integer offset = (Integer.valueOf(apexpages.currentpage().getparameters().get('offset')));
        Integer limitOffset = (Integer.valueOf(apexpages.currentpage().getparameters().get('limitOffset')));
        Boolean isHistory = (Boolean.valueOf(apexpages.currentpage().getparameters().get('isHistory')));
        String accId = apexpages.currentpage().getparameters().get('accId') == 'null'? null : apexpages.currentpage().getparameters().get('accId'); 
        String instructorId = apexpages.currentpage().getparameters().get('instructorId') == 'null'? null : apexpages.currentpage().getparameters().get('instructorId'); 
        system.debug('offset'+offset);
        system.debug('limitOffset'+limitOffset);
        system.debug('isHistory'+isHistory);
        system.debug('accId'+accId);
        system.debug('instructorId'+instructorId);
        classWrapperList = new List<PHSS_ClassListInstructorViewController.classWrapper>();
        limitOffset = Integer.valueOf(limitOffset);
        offset = Integer.valueOf(offset);
        Set<String> neededFields = new Set<String>{
            'Id'
                ,'redwing__ILT_Class__c'
                ,'redwing__ILT_Class__r.Name'
                ,'redwing__ILT_Class__r.ltui__Start_Time_Formatted__c'
                ,'redwing__ILT_Class__r.ltui__End_Time_Formatted__c'
                ,'redwing__ILT_Class__r.redwing__End_Date__c'
                ,'redwing__ILT_Class__r.redwing__Learning__c'
                ,'redwing__ILT_Class__r.redwing__Location__c'
                ,'redwing__ILT_Class__r.redwing__Location__r.redwing__Address_1__c'
                ,'redwing__ILT_Class__r.redwing__Location__r.redwing__City__c'
                ,'redwing__ILT_Class__r.redwing__Location__r.redwing__Country__c'
                ,'redwing__ILT_Class__r.redwing__Location__r.redwing__State__c'
                ,'redwing__ILT_Class__r.redwing__Location__r.redwing__Postal_Code__c'
                ,'redwing__ILT_Class__r.redwing__Start_Date__c'
                ,'redwing__ILT_Class__r.Class_Closed_Date__c'
                ,'redwing__ILT_Class__r.' + RCConstants.APINAME_FIELD_ORGANIZATION
                ,'redwing__ILT_Session__c'
                ,'redwing__Instructor__c'
                ,'redwing__Instructor__r.Name'    
                ,'redwing__Primary__c '
                };
                    
                    String instructId;
        if(instructorId != null && !String.isBlank(instructorId)) {
            instructId = instructorId;
        }
        else {
            instructId = UserInfo.getUserId();
        }
        String query = 'SELECT ' + String.join(new List<String>(neededFields), ', ') + ' FROM redwing__ILT_Instructor__c WHERE redwing__ILT_Class__c != null ';
        
        // Account condition
        if(accId != null && accId != '') {
            query += ' AND redwing__ILT_Class__r.Skedulo_Account__c = :accId ';
        }
        
        if(instructorId != null && !String.isBlank(instructorId)) {
            query += ' AND redwing__Instructor__c = :instructorId ';    
        }
        else {
            query += ' AND redwing__Instructor__c = \'' + UserInfo.getUserId() + '\'';
        }
        
        if(isHistory){
            query +=  'AND redwing__ILT_Class__r.redwing__End_Date__c < TODAY ';
        } else {
            query +=  'AND redwing__ILT_Class__r.redwing__End_Date__c >= TODAY ';
        }
        
        query +=  'ORDER BY redwing__ILT_Class__r.Name ASC ';
        if(Integer.valueOf(limitOffset) != 0){
            query +=  'LIMIT :limitOffset OFFSET :offset';
        }
        System.debug('query - ' + query);
        List<redwing__ILT_Instructor__c> instructors = Database.query(query);
        
        System.debug('>> instructors - ' + instructors);
        
        Set<String> classIds = new Set<String>();
        if(!instructors.isEmpty()){
            Set<String> learningIds = new Set<String>();
            for(redwing__ILT_Instructor__c item : instructors){
                learningIds.add(item.redwing__ILT_Class__r.redwing__Learning__c);
            }
            Map<String,  Map<String, redwing__Training_Plan__c>> learningId_tpaln = RCUtils.getPlanToLearningIds(learningIds);
            
            for(redwing__ILT_Instructor__c item : instructors){
                if(!classIds.contains(item.redwing__ILT_Class__c)){    
                    // Duration
                    Integer duration = 0;
                    if(item.redwing__ILT_Class__r.redwing__Start_Date__c != null && item.redwing__ILT_Class__r.redwing__End_Date__c != null){
                        duration = PHSS_ClassListInstructorViewController.getCountDays(item.redwing__ILT_Class__r.redwing__Start_Date__c, item.redwing__ILT_Class__r.redwing__End_Date__c);
                    }
                    
                    // Location
                    PHSS_ClassListInstructorViewController.LocationWrapper currentLocation = new PHSS_ClassListInstructorViewController.LocationWrapper();
                    if(item.redwing__ILT_Class__r.redwing__Location__c != null){
                        currentLocation.city        = item.redwing__ILT_Class__r.redwing__Location__r.redwing__City__c;
                        currentLocation.address1    = item.redwing__ILT_Class__r.redwing__Location__r.redwing__Address_1__c;
                        currentLocation.country     = item.redwing__ILT_Class__r.redwing__Location__r.redwing__Country__c;
                        currentLocation.province    = item.redwing__ILT_Class__r.redwing__Location__r.redwing__State__c;
                        currentLocation.postalCode  = item.redwing__ILT_Class__r.redwing__Location__r.redwing__Postal_Code__c;
                    }
                    
                    // Status 
                    String classStatus = RCConstants.STATUS_UPCOMING;
                    if(item.redwing__ILT_Class__r.redwing__Start_Date__c <= datetime.now()){
                        classStatus = RCConstants.STATUS_IN_PROGRESS;
                    }
                    if(item.redwing__ILT_Class__r.redwing__End_Date__c <= datetime.now()){
                        classStatus = RCConstants.STATUS_COMPLETED;
                    }
                    if(item.redwing__ILT_Class__r.Class_Closed_Date__c != null) {
                        classStatus = RCConstants.STATUS_REPORTED;
                    }
                    
                    String currentLearnId = item.redwing__ILT_Class__r.redwing__Learning__c;
                    if(learningId_tpaln.containsKey(currentLearnId)){
                        Map<String, redwing__Training_Plan__c> plansById = learningId_tpaln.get(currentLearnId);
                        for(String pId : plansById.keySet()){
                            PHSS_ClassListInstructorViewController.classWrapper tempClassWrap = new PHSS_ClassListInstructorViewController.classWrapper(item, plansById.get(pId), currentLocation, classStatus, duration);
                            classWrapperList.add(tempClassWrap);
                        }
                    } else{
                        PHSS_ClassListInstructorViewController.classWrapper tempClassWrap = new PHSS_ClassListInstructorViewController.classWrapper(item, null, currentLocation, classStatus, duration);
                        classWrapperList.add(tempClassWrap);
                    }
                }
            }
        }
    }
}