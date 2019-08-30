public class DropStudentController {
    @AuraEnabled
    public static List<voucherWrapper> getVouchers(String orderItemId)
    {
        
        List<voucherWrapper> voucherList = new List<voucherWrapper>();
        
        List<Voucher__c> vouchers = [SELECT Id, 
                                     		Name,
                                     		Voucher_Claim__c,
                                     		User__r.Name   
                                     FROM   Voucher__c
                                     WHERE  Status__c = 'Claimed' 
                                     AND	CC_Order_Item__c =: orderItemId];
        if (vouchers.size() > 0)
        {
            for(Voucher__c v : vouchers)
            {
                VoucherWrapper vWrapper = new VoucherWrapper();
                
                vWrapper.voucherId		= v.Id;
                vWrapper.voucherName	= v.Name;
                vWrapper.voucherClaim	= v.Voucher_Claim__c;
                vWrapper.user			= v.User__r.Name;
                
                voucherList.add(vWrapper);
            }
        }
        system.debug('***voucherList***'+voucherList);
        return voucherList;
    }
    
    @AuraEnabled
    public static void dropSlectedStudents(string voucherRecords)
	{
        
        List<Id> 		 voucherListIds 	= new List<Id>();
        List<Voucher__c> vouchersToUpdate 	= new List<Voucher__c>();
        
        if(!string.isBlank(voucherRecords))
        {   
            List<VoucherWrapper> lstVoucherRecords =  (List<VoucherWrapper>) System.JSON.deserialize(voucherRecords,List<VoucherWrapper>.class);
            
            for(VoucherWrapper vRecords : lstVoucherRecords)
            {
                if(vRecords.isSelected)
                {
                    system.debug('***vRecords***'+vRecords);
                    voucherListIds.add(vRecords.voucherId);
                }
            }
        }
        
        system.debug('voucherListIds***'+voucherListIds);
        
        if(voucherListIds.size() > 0)
        {
            for(Id vId : voucherListIds)
            {   
                Voucher__c v = new Voucher__c();
                
                v.Id				= vId;
                v.CC_Order__c		= null;
                v.CC_Order_Item__c	= null;
                v.CC_Cart_Item__c	= null;
                v.Opportunity__c	= null;
                v.RCO_Order_Id__c	= null;
                v.Online_Class__c	= null;
                v.CC_Product__c 	= null;
                v.Account__c		= null;
                v.User__c			= null;
                v.Status__c			= 'Issued';
                
                vouchersToUpdate.add(v);
            }
        }
        
        if (vouchersToUpdate.size() > 0)
        {
            update vouchersToUpdate;
        }
    }
    
    public class VoucherWrapper
	{
        
        @AuraEnabled public boolean isSelected 	{get;set;}
        @AuraEnabled public string voucherId 	{get;set;}
        @AuraEnabled public string voucherName 	{get;set;}
        @AuraEnabled public string voucherClaim {get;set;}
        @AuraEnabled public string user 		{get;set;}

        
        public VoucherWrapper()
        {
            isSelected 		= false;
            voucherName 	= '';
            voucherClaim 	= '';
            user			= '';
        }
    }

}