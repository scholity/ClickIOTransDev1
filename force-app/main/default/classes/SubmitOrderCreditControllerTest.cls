@isTest
public class SubmitOrderCreditControllerTest
{
    static testmethod void testSubmitOrderCredit()
    {
        ccrz__E_Product__c product1 = new ccrz__E_Product__c();
        product1.Name = 'Test Prod';
        product1.ccrz__SKU__c = String.ValueOf(System.Now());
        product1.ccrz__Quantityperunit__c = 2.0;
        product1.ccrz__StartDate__c =  System.Today().addDays(2);
        product1.ccrz__EndDate__c = System.Today().addDays(20);
        //product1.LMS_Learning_Plan__c = lPlan2.id;
        insert product1;
        
        ccrz__E_Order__c cco=new ccrz__E_Order__c();
        cco.NSSCCConnector_SFCC_Order_Number__c ='3114226';
        cco.NSSCCConnector_from_SFCC__c=true;
        insert cco;
        
        ccrz__E_OrderItem__c ccoItems= new ccrz__E_OrderItem__c();
        ccoItems.ccrz__Product__c =product1.Id;
        ccoItems.ccrz__Order__c=cco.id;
        ccoItems.ccrz__Price__c=100;
        ccoItems.ccrz__Quantity__c=100.00;
        ccoItems.ccrz__SubAmount__c=100.00;
        //ccoItems.ILT_Class__c=clsRecord.Id;
        insert ccoItems;
        
        ccrz__E_TransactionPayment__c ctp= new ccrz__E_TransactionPayment__c();
        insert ctp;
        
        test.startTest();
        	SubmitOrderCreditController.getOnAccountBoolean(cco.Id);
        test.stopTest();
    }
    
    

}