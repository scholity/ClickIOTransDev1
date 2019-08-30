public without sharing class skedJobAllocationtoILTInstructor {
    public Boolean updateRecords = false;
    public void afterInsert(List<sked__Job_Allocation__c> newRecords) {
        // Create dummy old list of allocations (Map with no values) so we have one entry point
        Map<Id, sked__Job_Allocation__c> oldRecords = new Map<Id, sked__Job_Allocation__c>();

        Set<Id> resourceIds = new Set<Id>();
        Set<Id> jobIds = new Set<Id>();
        List<sked__Job__c> jobList = new List<sked__Job__c>();

        Set<redwing__ILT_Instructor__c> ILTInstructorSet = new Set<redwing__ILT_Instructor__c>();
        Map<Id, Id> resourceToInstructorMap = getResourceInstructorMap(resourceIds);
        Map<Id, redwing__ILT_Class__c> jobToILTClassMap = getJobILTClassMap(jobIds);

        updateRecords = false;

        for (sked__Job_Allocation__c theJobAllocation : newRecords) {
            if (!'Deleted,Declined'.contains(theJobAllocation.sked__Status__c)) {
                resourceIds.add(theJobAllocation.sked__Resource__c);
                jobIds.add(theJobAllocation.sked__Job__c);
            }
        }

        // Get related job records
        jobList = [SELECT Id, Name, Is_Stacked_Class__c, Is_Master_Class__c, sked__Parent__c FROM sked__Job__c
            WHERE Id IN :jobIds];

        // Add dependent (stacked) classes to Job Id list
        jobList = addDependentStackedClasses(jobList);

        // Iterate across inserted Job Allocations
        for (sked__Job_Allocation__c theJobAllocation : newRecords) {
            // Determine ILT Class which this allocation maps to
            redwing__ILT_Class__c theClass = jobToILTClassMap.get(theJobAllocation.sked__Job__c);
            Id resourceId = theJobAllocation.sked__Resource__c;
            Id jobId = theJobAllocation.sked__Job__c;

            // Create new instructor assignment for this class (will use upsert in case this already exists)
            redwing__ILT_Instructor__c theILTInstructor = new redwing__ILT_Instructor__c();

            // USxxxx - Instructors are always to be associated to the ILT Class record (rather than ILT Session)
            // in order to provide support for community pages (session-level assignments don't display instructor in community)
            // Can only assign an Instructor to a Session **OR** a Class (not both)

            // The external Id insures that if the same instructor is assigned to multiple sessions
            // that they are only associated once at the ILT Class level

            theILTInstructor.Skedulo_Job_Id_External__c = jobId+':'+resourceId;
            theILTInstructor.redwing__Instructor__c = resourceToInstructorMap.get(resourceId);
            theILTInstructor.redwing__ILT_Class__c = theClass.Id;

            System.debug('Creating ILTInstructor:'+theILTInstructor);

            ILTInstructorSet.add(theILTInstructor);
        }
        upsertILTInstructors(ILTInstructorSet);
    }

    public void afterUpdate(List<sked__Job_Allocation__c> newRecords, Map<Id, sked__Job_Allocation__c> oldRecords) {

        updateRecords = true;

        //upsertILTInstructors(newRecords, oldRecords);
    }

    public Map<Id, Id> getResourceInstructorMap(Set<Id> resourceIds) {
        Map<Id, Id> resourceToInstructorMap = new Map<Id, Id>();

        if(!resourceIds.isEmpty()){
            for (redwing__Instructor__c instructor : [SELECT Id, Skedulo_Instructor__c, redwing__User__c FROM redwing__Instructor__c WHERE Skedulo_Instructor__c IN :resourceIds]) {
                if(instructor.Skedulo_Instructor_External__c != null){
                    resourceToInstructorMap.put(instructor.Skedulo_Instructor__c, instructor.redwing__User__c);
                }
            }
            System.debug('resourceToInstructorMap='+resourceToInstructorMap);
        }
        return resourceToInstructorMap;
    }

    public Map<Id, redwing__ILT_Class__c> getJobILTClassMap(Set<Id> jobIds) {
        Map<Id, redwing__ILT_Class__c> jobToILTClassMap = new Map<Id, redwing__ILT_Class__c>();

        if(!jobIds.isEmpty()){
            for (redwing__ILT_Class__c theClass : [SELECT Id, Name, Skedulo_Job_Id__c FROM redwing__ILT_Class__c WHERE Skedulo_Job_Id__c IN :jobIds]) {
                jobToILTClassMap.put(theClass.Skedulo_Job_Id__c, theClass);
            }
            System.debug('jobToILTClassMap='+jobToILTClassMap);
        }
        return jobToILTClassMap;
    }

    public void upsertILTInstructors(Set<redwing__ILT_Instructor__c> SetILTInstructor) {
        if(SetILTInstructor.size() > 0) {
            System.debug('SetILTInstructor='+SetILTInstructor);
            List<redwing__ILT_Instructor__c> lstILTInstructor = new List<redwing__ILT_Instructor__c>(SetILTInstructor);

            Schema.SObjectField f = redwing__ILT_Instructor__c.Fields.Skedulo_Job_Id_External__c;
            Database.UpsertResult[] results = Database.upsert(lstILTInstructor, f, false);
            System.debug('Update ILTinstructor>>>>'+results);

            for(Integer index = 0, size = results.size(); index < size; index++) {
                if(results[index].isSuccess()) {
                    if(results[index].isCreated()) {
                        System.debug(lstILTInstructor[index].Skedulo_Job_Id_External__c +' was created');
                    } else {
                        System.debug(lstILTInstructor[index].Skedulo_Job_Id_External__c +' was updated');
                    }
                }
            }
        }
    }

    public List<sked__Job__c> addDependentStackedClasses(List<sked__Job__c> jobList) {
        // Augment both updated and deleted job Lists as they may contain master classes for stacked classes
        // Workaround: Skedulo only assigns instructors to the master (parent) class in a stacked class.
        // This code block forces the child (dependent) classes to be updated when the master class is updated,
        // resulting in an assignment of an instructor to these dependent classes when an updated allocation
        // is received from Skedulo

        String objectName = 'sked__Job__c';
        String masterJobIds = '';
        String jobQuery = '';
        Set<Id> jobIds = new Set<Id>();

        for (sked__Job__c theJob : jobList) {
            jobIds.add(theJob.Id);
            if (theJob.Is_Stacked_Class__c==true && theJob.Is_Master_Class__c==true) {
                if (masterJobIds.length() > 0) {
                    masterJobIds += ',';
                }
                masterJobIds += '\''+theJob.Id+'\'';
            }
        }

        if (String.isNotBlank(masterJobIds)) {
            Map<String, Schema.SObjectField> jobFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();

            for(String theField : jobFields.keySet()) {
                if (jobQuery.length() > 0) {
                    jobQuery += ',';
                }
                jobQuery += theField;
            }
            // Build a query to return all of the dependent classes for each class contained in master job List
            jobQuery = 'Select '+jobQuery+' From '+objectName+' Where Is_Stacked_Class__c = true And Is_Master_Class__c = false ';
            jobQuery += ' And sked__Parent__c In ('+masterJobIds+')';

            List <sked__Job__c> dependentJobs = new List <sked__Job__c>();
            dependentJobs = Database.query(jobQuery);

            if (!dependentJobs.isEmpty()) {
                for (sked__Job__c theDependentJob : dependentJobs) {
                    if (!jobIds.contains(theDependentJob.Id)) {
                        jobList.add(theDependentJob);
                        jobIds.add(theDependentJob.Id);
                    }
                }
            }
        }
        return jobList;
    }
}