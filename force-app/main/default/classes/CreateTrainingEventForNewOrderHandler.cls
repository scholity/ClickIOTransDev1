/************************************************************************************************************************************
** Author: Salesforce Services
** Description: The purpose of this class is to complete the trigger actions with the help of the UserActions class 
************************************************************************************************************************************/
public with sharing class CreateTrainingEventForNewOrderHandler {
	public CreateTrainingEventForNewOrderHandler() {} 
    
    public void OnAfterInsert(List<Order> newOrders) {
    	CreateTrainingEventForNewOrder(newOrders);    
    }
    public void OnAfterUpdate(List<Order> newOrders, List<Order> OldOrders,  Map<ID, Order> newOrderMap , Map<ID, Order> oldOrderMap ) {
    	CreateTrainingEventForNewOrder(newOrders);    
    }
    
    public void CreateTrainingEventForNewOrder(List<Order> lstOrders){
    	List <Training_Events__c> newTrainingEvents = new List <Training_Events__c>();
    
        // Collect Order Ids
        List <Id> orderIds = new List <Id>();
        Map <Id, Id> orderMap = new Map <Id, Id>();
        for (Order o : lstOrders) {
            orderIds.add(o.Id);
            // Validate Opportunity for New Order is Closed and Won
            if (o.OpportunityId != null){
            	orderMap.put(o.Id, o.OpportunityId);    
            } 
        }
        //get the opprotunities for those orders
        List <Opportunity> orderOpportunityList = [Select Id, Name, AccountId, StageName From Opportunity Where Id in :orderMap.values() and StageName = 'Closed Won'];
        Map <Id, Opportunity> orderOpportunityMap = new Map <Id, Opportunity>();
        for (Opportunity o : orderOpportunityList){
            orderOpportunityMap.put(o.Id, o);
        }
		
        //getting all the training events for the opportunities and putting them in a map to check them in a loop        
		map<id,list<Training_Events__c>> mapOpportunityToTrainingEvents = new map<id,list<Training_Events__c>>();	
		for(Training_Events__c trainingevent : [Select Id,Opportunity__c From Training_Events__c Where Opportunity__c = :orderOpportunityList]){
			if(mapOpportunityToTrainingEvents.containsKey(trainingevent.Opportunity__c)){
				mapOpportunityToTrainingEvents.get(trainingevent.Opportunity__c).add(trainingevent);
			} else{
				list<Training_Events__c> lstTrnEvent = new list<Training_Events__c>();
				lstTrnEvent.add(trainingevent);
				mapOpportunityToTrainingEvents.put(trainingevent.Opportunity__c, lstTrnEvent);
			}
		}
        // Create a New Training Event for First Order Item Representing an FS or AP Class
        List <OrderItem> orderItemList = new List <OrderItem>();
        
        orderItemList = [Select Id, OrderId, OrderItemNumber, PricebookEntry.Product2.ProductCode,
                         PricebookEntry.Product2.Name From OrderItem Where OrderId In :orderIds Order By OrderItemNumber];
        
        for (Id orderId : orderMap.keySet()) {
            Id orderOpportunityId = orderMap.get(orderID);
            Opportunity orderOpportunity = orderOpportunityMap.get(orderOpportunityId);
            if (orderOpportunity.StageName == 'Closed Won') {
      
                // Validate that a Training Event Does Not Yet Exist for this Order
                List <Training_Events__c> opportunityTrainingEvents = new List <Training_Events__c>();
				opportunityTrainingEvents = mapOpportunityToTrainingEvents.get(orderOpportunityId);
                if (opportunityTrainingEvents != null && opportunityTrainingEvents.size() > 0) continue;
        
                
                
                for (OrderItem oi : orderItemList) {
                    String productCodePrefix = oi.PricebookEntry.Product2.ProductCode.substring(0,2);
                    if ('FSAP'.contains(productCodePrefix)) {
                    
                        Training_Events__c te = new Training_Events__c();
                        te.Opportunity__c = orderOpportunity.Id;
                        te.Account__c = orderOpportunity.AccountId;
                        te.Course_Id__c = oi.PricebookEntry.Product2.ProductCode;
                        te.Course_Name__c = oi.PricebookEntry.Product2.Name;
                        newTrainingEvents.add(te);
                        
                        break;
                    }
                }
            }
        }
    
        try {
            insert newTrainingEvents;
        }
        catch (Exception e)
        {
            e.getMessage();
        }
        
        }
}