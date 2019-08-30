public without sharing class RBCController {

    @AuraEnabled
    public static RBCWrapper initWrapper() {
        RBCWrapper cpsWrap = new RBCWrapper();
        // Get Organization name
//        List<User> userList = [Select Id,Name,ContactId From User Where Id = :UserInfo.getUserId()];
//        if(!userList.isEmpty() && userList[0].ContactId != null) {
//            List<Contact> conList = [Select Id,Account.Name From Contact Where Id = :userList[0].ContactId];
//            cpsWrap.accId = conList[0].Account.Id;
//            cpsWrap.accName = conList[0].Account.Name;
//        }

        // Initialize Session list
//        List<RBCWrapper.SessionWrapper> sessionWrapList = new List<RBCWrapper.SessionWrapper>();
//        RBCWrapper.SessionWrapper sessionWrap = new RBCWrapper.SessionWrapper();
//        sessionWrapList.add(sessionWrap);
//        cpsWrap.sessionList = sessionWrapList;

//        // Class Formats
//        List<String> formatsList = new List<String>();
//        Schema.DescribeFieldResult fieldResult = redwing__ILT_Class__c.Classroom_Setting__c.getDescribe();
//        List<Schema.PicklistEntry> entries = fieldResult.getPicklistValues();
//        for(Schema.PicklistEntry val : entries) {
//            if(val.getLabel() != 'Online') {
//                formatsList.add(val.getLabel());
//            }
//        }
//        cpsWrap.classFormatList = formatsList;

        // Timezone
//        skedJobtoILTClass localSkedJobtoILTClass = new skedJobtoILTClass();
//        cpsWrap.timeZoneList = localSkedJobtoILTClass.timeZoneMap;

        return cpsWrap;
    }

}