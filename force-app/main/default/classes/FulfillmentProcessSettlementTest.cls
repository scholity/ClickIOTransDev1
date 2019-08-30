@isTest
private class FulfillmentProcessSettlementTest {
    @isTest static void testProcessSettlement() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseCybersourceSettle());
        List<ID> testIDs = new List<ID>();
        testIDs.add('TP-0000000316');
        
        FulfillmentProcessSettlement.processSettlements(testIDs);
    }
}