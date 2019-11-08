public without sharing class getFeedbackSurveyController
{
    @AuraEnabled
    public static List<sObject> getPicklistValues(String objName, String accId) 
    {
        User usr = [SELECT id, ContactId, Name, Profile.Name, Profile.UserLicense.Name FROM User WHERE id=: UserInfo.getUserId()];
        String sQuery = '';
        if(objName == 'Account')
        {
            sQuery =  'Select id, Name From ' +objName + ' Where id in (SELECT AccountId FROM AccountContactRelation WHERE ContactId = \'' +usr.ContactId+'\') Order By Name ASC';
        }
        else if(ObjName == 'User')
        {
            List<String> ListRolesName= new List<String> {'Administrator','Instructor'};
                Boolean isInstructor = isInstructor(accId);
            
            if(isInstructor) {
                sQuery =  'Select id, Name From ' +objName + ' Where ContactId in (SELECT ContactId FROM AccountContactRelation WHERE AccountId = \'' +accId +'\' and ContactId = \'' +usr.ContactId+'\' and Roles IN: ListRolesName) Order By Name ASC';    
            }
            else {
                sQuery =  'Select id, Name From ' +objName + ' Where ContactId in (SELECT ContactId FROM AccountContactRelation WHERE AccountId = \'' +accId +'\' and Roles IN: ListRolesName) Order By Name ASC';    
            }
        }        
        List <sObject> lstOfRecords = Database.query(sQuery);
        return lstOfRecords;
    }
    
    @AuraEnabled
    public static List<surveyWrapper> getSurvey(String accId, String instId,  String classDateFrom, String classDateTo, String classId) 
    {
        System.debug('instId idd'+instId);
        System.debug('Accountidd >>>>'+accId);
        
        //Get List of Surveys with Given Instructors
        String accName = '';
        Map<Id, user> userIdAndNameMap = new Map<Id, user>();
        if(((List<Id>)JSON.deserializeStrict(accId ,List<Id>.class)).size () > 0)
        {
            List<Id> accIdsFromClient = (List<Id>)JSON.deserializeStrict(accId ,List<Id>.class);
            List<Account> accList = [select id, Name from Account where Id In : accIdsFromClient];
            accName = accList[0].Name;
        }
        
        List<redwing__ILT_Instructor__c> instructorsList = new List<redwing__ILT_Instructor__c>();
        if(((List<Id>)JSON.deserializeStrict(instId ,List<Id>.class)).size () > 0)
        {
            List<Id> userIdsFromClient = (List<Id>)JSON.deserializeStrict(instId ,List<Id>.class);
            userIdAndNameMap = new Map<ID, user>([SELECT Id, Name FROM user where Id In : userIdsFromClient]);
            instructorsList = [select Id, redwing__ILT_Class__c, redwing__Instructor__c from redwing__ILT_Instructor__c where redwing__Instructor__c In: userIdsFromClient And Account__c =: accName];
        }
        Map<Id, List<Id>> classesIdWithInstructorsList = new Map<Id, List<Id>>();
        for(redwing__ILT_Instructor__c indInstructorRec : instructorsList)
        {
            if(classesIdWithInstructorsList.containsKey(indInstructorRec.redwing__ILT_Class__c))
                classesIdWithInstructorsList.get(indInstructorRec.redwing__ILT_Class__c).add(indInstructorRec.redwing__Instructor__c);
            else
            {
                List<Id> instructorsIdsList = new List<Id>();
                instructorsIdsList.add(indInstructorRec.redwing__Instructor__c);
                classesIdWithInstructorsList.put(indInstructorRec.redwing__ILT_Class__c, instructorsIdsList);
            }
        }
        //Till here
        
        String sObjectQuery ='Select id, Name, GetFeedback_Aut__CompletionDate__c, GetFeedback_Aut__Language__c, ILT_Roster__r.redwing__ILT_Class__r.Offering_Id__c, ILT_Roster__r.redwing__ILT_Class__r.Skedulo_Account__r.Name, ILT_Roster__r.redwing__ILT_Class__r.redwing__Start_Date__c, ILT_Roster__r.redwing__ILT_Class__r.redwing__End_Date__c, (select id, GetFeedback_Aut__QuestionType__c, GetFeedback_Aut__DisplayValue__c, GetFeedback_Aut__QuestionTitle__c from GetFeedback_Aut__Answers__r) from GetFeedback_Aut__Response__c where Id != null';
        if(((List<Id>)JSON.deserializeStrict(accId ,List<Id>.class)).size () > 0)
        {
            List<Id> accIdsFromClient = (List<Id>)JSON.deserializeStrict(accId ,List<Id>.class);
            sObjectQuery  += ' And ILT_Roster__r.redwing__ILT_Class__r.Skedulo_Account__c In : accIdsFromClient';
        }
        
        //Start Date Condition
        date dateClassDateFrom;
        If(!String.isBlank(classDateFrom))
        {
            dateClassDateFrom = date.valueOf(classDateFrom);
            sObjectQuery += ' AND ILT_Roster__r.redwing__ILT_Class__r.redwing__Start_Date__c >= : dateClassDateFrom ';  
        }
        
        date dateClassDateTo;
        If(!String.isBlank(classDateTo))
        {
            dateClassDateTo = date.valueOf(classDateTo);
            sObjectQuery += ' AND ILT_Roster__r.redwing__ILT_Class__r.redwing__Start_Date__c <= : dateClassDateTo ';  
        }
        
        //Course Id Condition
        if(!String.isBlank(classId))
            sObjectQuery += ' AND ILT_Roster__r.redwing__ILT_Class__c = : classId ';
        
        List<GetFeedback_Aut__Response__c> feedBackResponse = Database.query(sObjectQuery);
        
        // Add data to wrapper list and display the details in the table
        List<surveyWrapper> surveyList = new List<surveyWrapper>();
        Map<Id, List<GetFeedback_Aut__Answer__c>> userIdsWithQuestions = new Map<Id, List<GetFeedback_Aut__Answer__c>>();
        for(GetFeedback_Aut__Response__c indResponse: feedBackResponse)
        {
            if(classesIdWithInstructorsList.containsKey(indResponse.ILT_Roster__r.redwing__ILT_Class__c))
            {
                if(((List<Id>)JSON.deserializeStrict(instId ,List<Id>.class)).size () > 0)
                {
                    List<Id> userIdsFromClient = (List<Id>)JSON.deserializeStrict(instId ,List<Id>.class);
                    for(Id indUserIdFromClient : userIdsFromClient)
                    {
                        if(classesIdWithInstructorsList.get(indResponse.ILT_Roster__r.redwing__ILT_Class__c).contains(indUserIdFromClient))
                        {
                            if(userIdsWithQuestions.containsKey(indUserIdFromClient))
                                userIdsWithQuestions.get(indUserIdFromClient).addAll(indResponse.GetFeedback_Aut__Answers__r);
                            else
                            {
                                List<GetFeedback_Aut__Answer__c> instructorAnswers = new List<GetFeedback_Aut__Answer__c>();
                                instructorAnswers.addAll(indResponse.GetFeedback_Aut__Answers__r);
                                userIdsWithQuestions.put(indUserIdFromClient, instructorAnswers);
                            }
                        }
                    }
                }
            }
        }
        
        System.debug('userIdsWithQuestions:::'+userIdsWithQuestions);
        
        Map<String, Integer> InstructorRatingsMap = new Map<String, Integer>();
        InstructorRatingsMap.put('Extremely poor', 1);
        InstructorRatingsMap.put('Below average', 2);
        InstructorRatingsMap.put('Average', 3);
        InstructorRatingsMap.put('Very good', 4);
        InstructorRatingsMap.put('Excellent', 5);
        
        
        Map<String, Integer> WillingnessToRespondMap = new Map<String, Integer>();
        WillingnessToRespondMap.put('Not prepared at all', 1);
        WillingnessToRespondMap.put('Somewhat unprepared', 2);
        WillingnessToRespondMap.put('Neither prepared or unprepared', 3);
        WillingnessToRespondMap.put('Somewhat prepared', 4);
        WillingnessToRespondMap.put('Very prepared', 5);
        
        
        for(Id instructorId : userIdsWithQuestions.keySet())
        {
            Decimal averageNPS = 0.00;
            Decimal averageInstructorRatings = 0.00;
            Decimal averageWillingnessToRespond = 0.00;
            
            Decimal sumNPS = 0;
            Decimal sumInstructorRatings = 0;
            Decimal sumWillingnessToRespond = 0;
            
            Decimal countNPS = 0;
            Decimal countInstructorRatings = 0;
            Decimal countWillingnessToRespond = 0;
            
            String NPSQuestion = 'Would you recommend this class?';
            String instructorRatingsQuestion = 'How would you rate your instructor during your recent course?';
            String WillingnessToRespondQuestion = 'After having taken this class, what is your willingness to respond in an emergency situation?';
            
            for(GetFeedback_Aut__Answer__c indAnswer : userIdsWithQuestions.get(instructorId))
            {
                if(indAnswer.GetFeedback_Aut__QuestionTitle__c == 'Would you recommend this class?')
                {
                    sumNPS = sumNPS + (indAnswer.GetFeedback_Aut__DisplayValue__c != null ? Integer.valueOf(indAnswer.GetFeedback_Aut__DisplayValue__c) : 0 );
                    countNPS = countNPS + 1;
                }
                else if(indAnswer.GetFeedback_Aut__QuestionTitle__c == 'How would you rate your instructor during your recent course?')
                {
                    sumInstructorRatings = sumInstructorRatings + (InstructorRatingsMap.containsKey(indAnswer.GetFeedback_Aut__DisplayValue__c) ? InstructorRatingsMap.get(indAnswer.GetFeedback_Aut__DisplayValue__c) : 0);
                    countInstructorRatings = countInstructorRatings + 1;
                }
                else if(indAnswer.GetFeedback_Aut__QuestionTitle__c == 'After having taken this class, what is your willingness to respond in an emergency situation?')
                {
                    sumWillingnessToRespond = sumWillingnessToRespond + (WillingnessToRespondMap.containsKey(indAnswer.GetFeedback_Aut__DisplayValue__c) ? WillingnessToRespondMap.get(indAnswer.GetFeedback_Aut__DisplayValue__c) : 0);
                    countWillingnessToRespond = countWillingnessToRespond + 1;
                }
            }
            
            if(sumNPS > 0 && countNPS > 0)
                averageNPS = (sumNPS/countNPS).setScale(2);
            
            if(sumInstructorRatings > 0 && countInstructorRatings > 0)
                averageInstructorRatings = (sumInstructorRatings/countInstructorRatings).setScale(2);
            
            if(sumWillingnessToRespond > 0 && countWillingnessToRespond > 0)
                averageWillingnessToRespond = (sumWillingnessToRespond/countWillingnessToRespond).setScale(2);
            
            surveyList.add(new surveyWrapper(accName, userIdAndNameMap.get(instructorId).Name, NPSQuestion, String.valueOf(averageNPS)));
            surveyList.add(new surveyWrapper(accName, userIdAndNameMap.get(instructorId).Name, instructorRatingsQuestion, String.valueOf(averageInstructorRatings)));
            surveyList.add(new surveyWrapper(accName, userIdAndNameMap.get(instructorId).Name, WillingnessToRespondQuestion, String.valueOf(averageWillingnessToRespond)));
        }
        
        System.debug('surveyList>>>>>>>>>>>>>>>>'+surveyList);
        return surveyList;
    }
    
    public static Boolean isInstructor(String accId) 
    {
        User usr = [Select Id,Name,Profile.Name, ContactId From User Where Id = :UserInfo.getUserId()];  
        if(usr.Profile.Name.containsIgnoreCase('partner')) 
        {
            List<AccountContactRelation> accountConRelation = [select id, Roles from AccountContactRelation where AccountId =: accId And ContactId =: usr.ContactId AND Roles includes ('Administrator')];
            if(accountConRelation.size() > 0)
                return false;
            else
                return true;
        }
        return true;
    }
    
    public class surveyWrapper 
    {
        @AuraEnabled public String OrganizationName;
        @AuraEnabled public String InstructorName;
        @AuraEnabled public String question;
        @AuraEnabled public String Responce;
        public surveyWrapper(String OrganizationName, String InstructorName, String question, String Responce) 
        {
            this.OrganizationName = OrganizationName;
            this.InstructorName = InstructorName;
            this.question = question;
            this.Responce = Responce;
        }
    }
}