/**
 * Created by jason.harris on 2019-06-26.
 */

@isTest
public with sharing class PHSS_GenerateCSVFileBatchTest2 {

    static testMethod void testIntegrationFileCreation() {
        Test.startTest();
        PHSS_GenerateCSVFileBatch csvFileBatch = new PHSS_GenerateCSVFileBatch();
        //Id batchId = Database.executeBatch(csvFileBatch,100);
        Test.stopTest();
    }
}